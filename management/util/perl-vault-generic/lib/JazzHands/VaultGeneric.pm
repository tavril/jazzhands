package JazzHands::VaultGeneric;

use strict;
use warnings;
use Exporter;
use LWP::UserAgent;
use JSON::PP;
use Data::Dumper;

use JazzHands::Common qw(_options SetError $errstr );
use parent 'JazzHands::Common';

use vars qw(@EXPORT_OK @ISA $VERSION);

$VERSION = '0.86';
@ISA       = qw(JazzHands::Common Exporter);
@EXPORT_OK = qw();

our $AUTOLOAD;
#our @ISA = qw(Exporter);
#our @EXPORT_OK = qw();


##############################################################################
# Creating a new Vault instance
#
# Parameters
# - uri: base URL for reaching VAULT.
#        If VAULT_ADDR environment variable is set, it wins.
# - role_id and role_id_file:
#        If both parameters are specified, role_id_file wins.
# - secret_id and secret_id_file:
#        If both parameters are specified, secret_id_file wins.
# - token and token_file:
#        If both parameters are specified, secret_id_file wins.
##############################################################################
sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = bless {}, $class;

    my %args = @_;

    if ( $ENV{VAULT_ADDR} ) {
        $self->{_uri} = $ENV{VAULT_ADDR};
    } else {
        $self->{_uri} = $args{uri} if defined $args{uri};
    }

    $self->{_role_id} = $args{role_id} if defined $args{role_id};
    $self->{_role_id_file} = $args{role_id_file} if defined $args{role_id_file};
    $self->{_secret_id} = $args{secret_id} if defined $args{secret_id};
    $self->{_secret_id_file} = $args{secret_id_file} if defined $args{secret_id_file};
    $self->{_token} = $args{token} if defined $args{token};
    $self->{_token_file} = $args{token_file} if defined $args{token_file};

    # files always win (if _role_id_file is present, it overwrites _role_id)
    foreach my $i (qw(_role_id_file _secret_id_file _token_file )) {
        if ( $self->{$i} and -f $self->{$i} ) {
            my $FH;
            if ( !open ($FH, '<', $self->{$i} )) {
                $errstr = sprintf "Unable to open %s: %s", $self->{$i}, $!;
                return undef;
            }
            my $j = $i =~ s/_file//r;
            $self->{$j} = <$FH>;
            close $FH;
            chomp $self->{$j};
        }
    }

    $self;
}


##############################################################################
# Let's user AUTOLOAD as generic getter/setter function.
# - Call vault->role_id() and it will get _role_id property.
# - Call vault->role_id('123') and it will set _role_id property to '123'.
##############################################################################
sub AUTOLOAD {
    my $self = shift;

    my $ref = ref $self; # class name, i.e. Vault.
    (my $attr = $AUTOLOAD) =~ s/$ref\:\:/_/;

    if (@_) {
        $self->{$attr} = shift;

        # If we are setting _role_id_file, _secret_id_file, or _token_id_file,
        # then let's read the file and set _role_id, _secret_id or _token_id.
        if ($attr =~ /_file$/) {
            return undef unless -f $self->{$attr};
            my $FH;
            if ( !open ($FH, '<', $self->{$attr} )) {
                $errstr = sprintf "Unable to open %s: %s", $self->{$attr}, $!;
                return undef;
            }
            (my $i = $attr) =~ s/_file//;
            $self->{$i} = <$FH>;
            close $FH;
            chomp $self->{$i};
        }
    }
    return $self->{$attr};
}


##############################################################################
# _req sends a HTTP request to VAULT.
# In case of issue:
#   - display error message
#   - returns undef
# Otherwise return content or {} if no content.
##############################################################################
sub _req {
    my $self = shift;
    my %params = @_;
    $params{method} //= 'GET';
    my $url = join("/", $self->{_uri}, 'v1', $params{path});

    my $ua = LWP::UserAgent->new();
    my $req = HTTP::Request->new( $params{method} => $url);

    if ( $self->{_token} ) {
        $req->header( 'X-Vault-Token' => $self->{_token});
    }

    if ( $params{data}) {
        my $json = JSON::PP->new();
        my $body = $json->encode($params{data});
        $req->content_type('application/json');
        $req->content($body);
    }
    #print Dumper $req;

    my $res = $ua->request($req);
    my $json = JSON::PP->new();

    if ( !$res->is_success) {
        # let's not report error when trying lookup-self
        # (if we don't have a token yet, we will get an error 400 bad request)
        if ( $res->content and
            ($params{path} ne 'auth/token/lookup-self' or
                ($params{path} eq 'auth/token/lookup-self' and $res->code != 400)
            )
        ) {
            my $vaulterr;
            eval {
                $vaulterr = $json->decode( $res->content );
                if ( exists($vaulterr->{errors}) ) {
                    $errstr = sprintf "%s: (%s): %s\n", $url, $res->code, join( ",", @{ $vaulterr->{errors} } );
                }
            };
        }
        return undef;
    }
    if ( $res->content) {
        $json->decode( $res->content );
    } else {
        return {};
    }
}

##############################################################################
# If the object doesn't have a token, or if the token is invalid
# (or TTL low), then this function will try to obtain a new token.
#
# When obtaining a new token, the token gets writen to the file referenced by
# object's property _token_file (if it exists).
#
# In case of issue, returns undef. Otherwise return the token.
##############################################################################
sub get_token {
    my ($self, $ttl_refresh_seconds) = @_;
    $ttl_refresh_seconds //= 300;

    if ( ! $self->{_uri} ) {
        $errstr = "Missing uri";
        return undef;
    }

    if ( ! $self->{_role_id} ) {
        $errstr = "Missing role_id";
        return undef;
    }
    if (! $self->{_secret_id}) {
        $errstr = "Missing secret_id";
        return undef;
    }

    # If $self->_token is set, it will use it,
    # so it will test the validity of the token.
    my $data;
    $data = $self->_req(
        path => 'auth/token/lookup-self',
    );
    if ( $data->{data} ) {
        my $ttl = int($data->{data}->{ttl});
        if ($ttl > $ttl_refresh_seconds) {
            return 0;
        } else {
            printf STDERR "Token TTL (%d) is lower than limit (%d). Getting new one\n", $ttl, $ttl_refresh_seconds;
        }
    }

    # Either we don't have a token yet, or the TTL is too low.
    # Let's get a new Token.
    my $post = {
        'role_id'   => $self->{_role_id},
        'secret_id' => $self->{_secret_id},
    };

    if ( ! defined($data = $self->_req(
        method => 'POST',
        path   => 'auth/approle/login',
        data   => $post
    ))) {
        return undef;
    }

    my $token = $data->{auth}->{client_token};
    $self->{_token} = $token;

    # let's not die if we cannot write the token file.
    if ( $self->{_token_file} ) {
        open(FH, '>', $self->{_token_file}) or $errstr = $!;
        printf FH "%s\n", $self->{_token};
        close(FH);
    }

    return $self->{_token};
}


##############################################################################
sub revoke_token {
    my $self = shift;
    if ( $self->{_token} ) {
        if (! defined($self->_req(
            method => 'POST',
            path   => 'auth/token/revoke-self',
            data   => '',
        ))) {
            $errstr = "Error while trying to revoke token";
            return undef;
        }
    }
    # Should we delete the token even if we couldn't revoke it ?
    delete( $self->{_token} );
}


##############################################################################
# Write some data into Vault.
##############################################################################
sub write {
    my ($self, $path, $data) = @_;
    if (! defined($self->_req(
        method => 'POST',
        path   => $path,
        data   => {
            'data' => $data,
        },
    ))) {
        $errstr = sprintf "Error while trying to write in %s\n", $path;
        return undef;
    }
    return 1;
}


##############################################################################
# Read some data from Vault.
##############################################################################
sub read {
    my ($self, $path) = @_;
    my $data;
    if (! defined($data = $self->_req(
        path => $path,
    ))) {
        $errstr = sprintf "Error while trying to read %s\n", $path;
        return undef;
    }
    return $data->{data};
}


##############################################################################
# Delete some data from Vault.
##############################################################################
sub delete {
    my ($self, $path) = @_;
    if (! defined($self->_req(
        method => 'DELETE',
        path   => $path,
    ))) {
        $errstr = sprintf "Error, cannot delete at %s\n", $path;
        return undef;
    }
    return 1;
}


##############################################################################
# Delete metadata from Vault
# Ex.: you have 'global/kv/data/services/<service>/foo name=foo pass=bar'
#
# --> use 'delete' method on 'global/kv/data/services/<service>/foo'
#     in order to delete the secrets (name and pass in this example)
# --> Use 'delete_metadata' method on 'global/kv/data/services/<service>/foo'
#     in order to delete the 'foo' path.
##############################################################################
sub delete_metadata {
    my ($self, $path) = @_;
    (my $real_path = $path) =~ s/\/data\//\/metadata\//;

    if (! defined($self->_req(
        method => 'DELETE',
        path   => $real_path,
    ))) {
        $errstr = sprintf "Error, cannot delete metadata for %s\n", $path;
        return undef;
    }

    return 1;
}


##############################################################################
# List some metadata from Vault.
##############################################################################
sub list {
    my ($self, $path) = @_;
    (my $real_path = $path) =~ s/\/data\//\/metadata\//;

    my $data;
    if (! defined($data = $self->_req(
        method => 'LIST',
        path   => $real_path,
    ))) {
        $errstr = sprintf "Error, cannot list at %s\n", $path;
        return undef;
    }

    return $data->{data}->{keys};
}

1;
