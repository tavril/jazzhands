Name:   	jazzhands-perl-mgmt
Version:        __VERSION__
Release:        0%{?dist}
Summary:        JazzHands Management Perl Libraries
Group:  	System Environment/Libraries
License:        BSD
URL:    	http://www.jazzhands.net/
Source0:        %{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-buildroot
BuildArch:	noarch
BuildRequires:	make
%if 0%{?suse_version}
BuildRequires: perl(ExtUtils::MakeMaker)
%else
BuildRequires: perl-generators
BuildRequires: perl-interpreter
%if 0%{?rhel} < 6
BuildRequires: perl(ExtUtils::MakeMaker)
%else
BuildRequires: perl-ExtUtils-MakeMaker
%endif
%endif
#Requires:      	php

%description

ORM for perl for JazzHands. (to be deprecated0

%prep
%setup -q -n %{name}-%{version}
make -f Makefile.jazzhands BUILDPERL=%{__perl}

%install
make -f Makefile.jazzhands DESTDIR=%{buildroot} BUILDPERL=%{__perl} install

%clean
make -f Makefile.jazzhands clean

%files
%defattr(-,root,root)
%{perl_vendorlib}/*
%{_mandir}/man3/*
