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

PREFIX ?= /usr

all:

install:
	rm -rf $(DESTDIR)
	mkdir -p $(DESTDIR)/$(PREFIX)/libexec/jazzhands/mkpasswdfiles
	for file in mkpasswdfiles.pl ; do \
		newfn=`echo $$file | sed 's/\..*$$//'` ;\
		install -m 555  $$file $(DESTDIR)/$(PREFIX)/libexec/jazzhands/mkpasswdfiles/$$newfn ;\
	done

clean:
	[ -z "$(DESTDIR)" ] || rm -rf $(DESTDIR)
