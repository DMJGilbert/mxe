PKG             := vlc
$(PKG)_VERSION  := 2.2.2
$(PKG)_CHECKSUM := 9ad23128be16f9b40ed772961272cb0748ed8e4aa1bc79c129e589feebea5fb5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG).tar.xz
$(PKG)_WEBSITE  := http://videolan.org
$(PKG)_URL      := http://ftp.videolan.org/pub/videolan/$(PKG)/$($(PKG)_VERSION)/$(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_DEPS     := gcc qt dbus lua libgcrypt libmad gnutls ffmpeg

define $(PKG)_BUILD
    cd '$(1)' && ./bootstrap
    cd '$(1)' && PKG_CONFIG_PATH='$(PREFIX)/$(TARGET)/' \
    CFLAGS="-I$(PREFIX)/$(TARGET)/include" \
    LDFLAGS="-L$(PREFIX)/$(TARGET)/lib" \
    ./configure \
    	--prefix='$(PREFIX)/$(TARGET)' \
    	--with-mad='$(PREFIX)/$(TARGET)' \
    	LIBXML2_CFLAGS="-I$(PREFIX)/$(TARGET)/include/libxml2" \
    	--host=x86_64-w64-mingw32 \
    	LUA_CFLAGS='-I$(PREFIX)/$(TARGET)/include' \
    	LUA_LIBS='-L$(PREFIX)/$(TARGET)/lib -llua' \
    	LUAC=$(PREFIX)/$(TARGET)/bin/luac \
        --disable-lua \
    	--disable-libgcrypt \
    	--disable-directx \
    	--enable-static=yes \
    	--disable-shared \
    	--disable-vlc \
    	--disable-a52 \
    	--disable-avcodec \
    	--disable-swscale

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
