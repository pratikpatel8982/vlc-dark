# winpthreads

WINPTHREADS_VERSION := 5.0.3
WINPTHREADS_URL := https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v$(WINPTHREADS_VERSION).tar.bz2/download

ifdef HAVE_WIN32
PKGS += pthreads
endif
ifndef HAVE_WINSTORE
PKGS_FOUND += pthreads
endif

$(TARBALLS)/mingw-w64-v$(WINPTHREADS_VERSION).tar.bz2:
	$(call download_pkg,$(WINPTHREADS_URL),winpthreads)

.sum-pthreads: mingw-w64-v$(WINPTHREADS_VERSION).tar.bz2

pthreads: mingw-w64-v$(WINPTHREADS_VERSION).tar.bz2 .sum-pthreads
	$(UNPACK)
	$(APPLY) $(SRC)/pthreads/pthread-fix-inline.patch
	$(APPLY) $(SRC)/pthreads/pthreads-fix-old-mingw.patch
	$(MOVE)

.pthreads: pthreads
	$(REQUIRE_GPL)
	cd $</mingw-w64-libraries/winpthreads && $(HOSTVARS) ./configure $(HOSTCONF)
	cd $< && $(MAKE) -C mingw-w64-libraries -C winpthreads install
	touch $@
