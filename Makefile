# For BSD, AIX, Solaris:
V:sh = cat VERSION
D:sh = date +'%d %b %Y'
Y:sh = date +'%Y'

# for GNU Make:
V ?= $(shell cat VERSION)
D ?= $(shell date +'%d %b %Y')
Y ?= $(shell date +'%Y')

TARBALL_CONTENTS=keychain README.md ChangeLog.md COPYING.txt MAINTAINERS.txt keychain.pod keychain.1 keychain.spec

all: keychain.1 keychain keychain.spec

.PHONY : tmpclean
tmpclean:
	rm -rf dist keychain.1.orig keychain.txt

.PHONY : clean
clean: tmpclean
	rm -rf keychain.1 keychain keychain.spec

keychain.spec: keychain.spec.in keychain.sh
	sed 's/KEYCHAIN_VERSION/$V/' keychain.spec.in > keychain.spec

keychain.1: keychain.pod keychain.sh
	pod2man --name=keychain --release=$V \
		--center='https://www.funtoo.org' \
		keychain.pod keychain.1
	sed -i.orig -e "s/^'br/.br/" keychain.1

keychain.1.gz: keychain.1
	gzip -9 keychain.1

GENKEYCHAINPL = open P, "keychain.txt" or die "cannot open keychain.txt"; \
			while (<P>) { \
				$$printing = 0 if /^\w/; \
				$$printing = 1 if /^(SYNOPSIS|OPTIONS)/; \
				$$printing || next; \
				s/\$$/\\\$$/g; \
				s/\`/\\\`/g; \
				s/\\$$/\\\\/g; \
				s/\*(\w+)\*/\$${CYAN}$$1\$${OFF}/g; \
				s/(^|\s)(-+[-\w]+)/$$1\$${GREEN}$$2\$${OFF}/g; \
				$$pod .= $$_; \
			}; \
		open B, "keychain.sh" or die "cannot open keychain.sh"; \
			$$/ = undef; \
			$$_ = <B>; \
			s/INSERT_POD_OUTPUT_HERE[\r\n]/$$pod/ || die; \
			s/\#\#VERSION\#\#/$V/g || die; \
		print

keychain: keychain.sh keychain.txt VERSION MAINTAINERS.txt
	perl -e '$(GENKEYCHAINPL)' | sed -e 's/##CUR_YEAR##/$(Y)/g' >keychain || rm -f keychain
	chmod +x keychain

keychain.txt: keychain.pod
	pod2text keychain.pod keychain.txt

keychain-$V.tar.gz: $(TARBALL_CONTENTS)
	mkdir keychain-$V
	cp $(TARBALL_CONTENTS) keychain-$V
	/bin/tar czvf keychain-$V.tar.gz keychain-$V
	rm -rf keychain-$V
	ls -l keychain-$V.tar.gz
