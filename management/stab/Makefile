#
# Copyright (c) 2016, Todd M. Kover
# All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

prefix		?= /var/www/stab
BUILDPERL	?= perl

all:
	echo Nothing to do for web site
	echo Building perl modules
	cd perl/src && $(BUILDPERL) Makefile.PL INSTALLDIRS=vendor --default
	echo Done with all

install:
	@ if [ -z "$(DESTDIR)" ] ; then echo 1>&2 Must set DESTDIR;exit 1;fi
	echo Doing install
	rm -rf $(DESTDIR)
	mkdir -p $(DESTDIR)/${prefix}

	(cd web/src/web && tar cf - . ) | (cd $(DESTDIR)/${prefix} ; tar xpvf - )
	cd perl/src && make pure_install


	find $(DESTDIR) -type f -name .packlist -exec rm -f {} \;
	find $(DESTDIR) -depth -type d -exec rmdir {} 2>/dev/null \;
	find $(DESTDIR) -name Makefile -print |xargs rm -f
	echo Done install

clean:
	(cd perl/src && [ -r Makefile ] && make distclean || true )


distclean: clean
