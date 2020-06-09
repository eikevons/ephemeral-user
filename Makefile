TARGETUSER ?= ephemeral
PREFIX ?= /usr/local
CONTROLSCRIPT := $(PREFIX)/sbin/$(TARGETUSER)-home-overlay

SERVICENAME := $(TARGETUSER)-home-overlay.service

BUILDTARGETS := build/bin/$(TARGETUSER)-clear build/sbin/$(TARGETUSER)-home-overlay build/share/home-overlay/$(TARGETUSER)-home-overlay.service
INSTALLTARGETS := $(PREFIX)/bin/$(TARGETUSER)-clear $(CONTROLSCRIPT) $(PREFIX)/share/home-overlay/$(TARGETUSER)-home-overlay.service

build: build/bin/$(TARGETUSER)-clear build/sbin/$(TARGETUSER)-home-overlay build/share/home-overlay/$(TARGETUSER)-home-overlay.service

check:
	-@which install >/dev/null || { echo "Missing command: install"; false; }
	-@[ -e /usr/sbin/adduser ] || { echo "Missing command: adduser"; false; }
	-@which sudo >/dev/null || { echo "Missing command: sudo"; false; }

clean:
	rm -rf build

build/bin build/sbin build/share/home-overlay:
	mkdir -p $@

build/bin/$(TARGETUSER)-clear: clear | build/bin
	cp $< $@
	sed -i "s/#TARGETUSER#/$(TARGETUSER)/" $@

build/sbin/$(TARGETUSER)-home-overlay: home-overlay | build/sbin
	cp $< $@
	sed -i "s/#TARGETUSER#/$(TARGETUSER)/" $@

build/share/home-overlay/$(TARGETUSER)-home-overlay.service: home-overlay.service | build/share/home-overlay
	cp $< $@
	sed -i "s,#CONTROLSCRIPT#,$(CONTROLSCRIPT)," $@

$(PREFIX)/bin/$(TARGETUSER)-clear: build/bin/$(TARGETUSER)-clear
	install -D -m 0755 $< $@

$(PREFIX)/sbin/$(TARGETUSER)-home-overlay: build/sbin/$(TARGETUSER)-home-overlay
	install -D -m 0755 $< $@

$(PREFIX)/share/home-overlay/$(TARGETUSER)-home-overlay.service: build/share/home-overlay/$(TARGETUSER)-home-overlay.service
	install -D -m 0644 $< $@

install: check user $(INSTALLTARGETS)
	systemctl link $(PREFIX)/share/home-overlay/$(SERVICENAME) \
	    && systemctl enable $(SERVICENAME)

user:
	@id $(TARGETUSER) >/dev/null 2>&1 && { \
	    echo "User $(TARGETUSER) already exists"; \
	} || { \
	    echo "Creating user $(TARGETUSER)"; \
	    adduser --disabled-login $(TARGETUSER); \
	}

sudo-snippet:
	@echo "$(USER) ALL = (ALL) NOPASSWD: /bin/systemctl start $(SERVICENAME), /bin/systemctl stop $(SERVICENAME)"

.PHONY: build check clean install user
