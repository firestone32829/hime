include config.mak

VERSION_FILE = ChangeLog

DIR    = src data filter scripts icons man menu

ifeq ($(ECHO),)
ECHO  := $(shell whereis -b echo | awk '{print $$2}')
ifeq ($(ECHO),)
ECHO   = echo
endif
endif

ifeq ($(USE_I18N),Y)
DIR   += po
endif

.PHONY: all
all:
	@for d in $(DIR); do $(ECHO) -e "\x1b[1;33m** processing $$d\x1b[0m"; \
	   $(MAKE) -C $$d || exit 1; \
	done

.PHONY: install
install:
	@for d in $(DIR); do $(ECHO) -e "\x1b[1;32m** installing $$d\x1b[0m"; \
	   $(MAKE) -C $$d install || exit 1; \
	done
	@if [ "$(prefix)" = /usr/local ]; then \
	   install -d "$(DOC_DIR)"; \
	   install -m 644 ChangeLog "$(DOC_DIR)"; \
	else \
	   install -d "$(DOC_DIR_i)"; \
	   install -m 644 ChangeLog "$(DOC_DIR_i)"; \
	fi

.PHONY: uninstall
uninstall:
	@for d in $(DIR); do $(ECHO) -e "\x1b[1;32m** uninstalling $$d\x1b[0m"; \
	   $(MAKE) -C $$d uninstall || exit 1; \
	done

.PHONY: clean
clean:
	@touch src/.depend
	@for d in $(DIR); do $(ECHO) -e "\x1b[1;31m** cleanup $$d\x1b[0m"; \
	   $(MAKE) -C $$d clean; \
	done

.PHONY: distclean
distclean:
	@$(MAKE) clean
	@rm -f config.mak

config.mak: $(VERSION_FILE) configure
	@$(ECHO) "regenerate $@ ..."
	./configure



