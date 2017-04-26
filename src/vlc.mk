PKG             := vlc
$(PKG)_VERSION  := 2.2.2
$(PKG)_CHECKSUM := 9ad23128be16f9b40ed772961272cb0748ed8e4aa1bc79c129e589feebea5fb5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG).tar.xz
$(PKG)_WEBSITE  := http://videolan.org
$(PKG)_URL      := ftp://ftp.videolan.org/pub/videolan/vlc/$($(PKG)_VERSION)/$($(PKG)_VERSION).tar.xz
$(PKG)_DEPS     := gcc qt dbus lua libgcrypt gnutls ffmpeg

define $(PKG)_BUILD
    cd '$(1)' && $(PREFIX)/bin/$(TARGET)-qmake

    $(MAKE) -C '$(1)'  -j '$(JOBS)'

    $(MAKE) -C '$(1)'  -j '$(JOBS)' install
endef
