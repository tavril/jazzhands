#
# Copyright (c) 2005-2010, Vonage Holdings Corp.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY VONAGE HOLDINGS CORP. ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL VONAGE HOLDINGS CORP. BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Makefile for enroll
#
# $Id
#
SRCDIR=src/

PWD=$(shell pwd)

INSTALLDIR=/prod/www/setup/data
INSTALL=/usr/ucb/install

JAVASCRIPT_FILES= prototype.js

all:
	@echo Nothing to build

install:
	rm -rf fakeroot
	mkdir -p fakeroot/$(INSTALLDIR)

	$(INSTALL) -o root -g bin -m 755 -d fakeroot/$(INSTALLDIR)
	( cd src ; find . -depth -print | cpio -pdm ../fakeroot/$(INSTALLDIR) )
	chown -R root fakeroot/$(INSTALLDIR)
	chgrp -R bin fakeroot/$(INSTALLDIR)
	find fakeroot/$(INSTALLDIR) -name .svn | xargs rm -rf
	find fakeroot/$(INSTALLDIR) -type d -print | xargs chmod 755
	find fakeroot/$(INSTALLDIR) -type f -print | xargs chmod 444

clean:
	cd ${SRCDIR} && if [ -f Makefile ] ; then ${MAKE} clean; fi
	rm -rf spool scratch fakeroot

