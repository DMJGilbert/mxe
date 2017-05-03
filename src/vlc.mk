PKG             := vlc
$(PKG)_VERSION  := 2.2.4
$(PKG)_CHECKSUM := 1632e91d2a0087e0ef4c3fb4c95c3c2890f7715a9d1d43ffd46329f428cf53be
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG).tar.xz
$(PKG)_WEBSITE  := http://videolan.org
$(PKG)_URL      := http://ftp.videolan.org/pub/videolan/$(PKG)/$($(PKG)_VERSION)/$(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_DEPS     := gcc qt dbus lua libgcrypt libmad gnutls ffmpeg \
                mingw-w64 libdvdread libshout faad2 a52dec twolame flac speexdsp gstreamer \
                libmodplug libcddb smpeg2 libgcrypt jack librsvg libsamplerate glew

define $(PKG)_BUILD
    # Enforce static - https://wiki.videolan.org/Win32Compile/#Static_compilation_of_plugins
    #/build/mxe/usr/lib/gcc/x86_64-w64-mingw32.static/5.4.0/
    #/build/mxe/usr/x86_64-w64-mingw32.static/lib/

    cd /build/mxe/usr/lib/gcc/x86_64-w64-mingw32.static/5.4.0/ && rm -f libstdc++-6.dll libstdc++.dll.a libgcc_s.a libgcc_s_sjlj-1.dll && true
    cd /build/mxe/usr/x86_64-w64-mingw32.static/lib/ && rm -f libstdc++-6.dll libstdc++.dll.a libgcc_s.a libgcc_s_sjlj-1.dll && true

    cd /build/mxe/usr/lib/gcc/x86_64-w64-mingw32.static/5.4.0/ && rm -f libpthread.dll.a libwinpthread.dll.a && true
    cd /build/mxe/usr/x86_64-w64-mingw32.static/lib/ && rm -f libpthread.dll.a libwinpthread.dll.a && true

    cd /build/mxe/usr/lib/gcc/x86_64-w64-mingw32.static/5.4.0/ && ln -s libgcc_eh.a libgcc_s.a
    cd /build/mxe/usr/x86_64-w64-mingw32.static/lib/ && ln -s libgcc_eh.a libgcc_s.a

    rm -f /build/mxe/usr/lib/gcc/x86_64-w64-mingw32.static/bin/libwinpthread-1.dll && true
    rm -f  /build/mxe/usr/x86_64-w64-mingw32.static/bin/libwinpthread-1.dll && true

    #Bootstrap
    cd '$(1)' && ./bootstrap
    cd '$(1)' && ./extras/package/win32/configure.sh \
        $(MXE_CONFIGURE_OPTS) \
    	--with-mad='$(PREFIX)/$(TARGET)' \
        --enable-ffmpeg \
        --with-ffmpeg-mp3lame \
        --with-ffmpeg-faac \
        --with-ffmpeg-zlib \
        --disable-qt \
        --disable-libgcrypt \
        --disable-update-check \
        --disable-dbus \
        --disable-dbus-control \
        --disable-lua \
    	--disable-directx \
        --disable-avcodec \
        $(if $(BUILD_STATIC), \
            --enable-static --disable-shared , \
            --disable-static --enable-shared ) \
    	--disable-vlc \
        --disable-dca \
    	--disable-swscale \
        --disable-live555 \
        --disable-schroedinger \
        --disable-goom \
        --disable-qt4 --disable-skins2

    #    LDFLAGS="-L$(PREFIX)/$(TARGET)/lib" \
    #    LIBXML2_CFLAGS="-I$(PREFIX)/$(TARGET)/include/libxml2" \
    #    LUA_CFLAGS='-I$(PREFIX)/$(TARGET)/include' \
    #    LUA_LIBS='-L$(PREFIX)/$(TARGET)/lib -llua' \
    #    LUAC=$(PREFIX)/$(TARGET)/bin/luac \
    #     PKG_CONFIG_PATH='$(PREFIX)/$(TARGET)/' \
    #    CFLAGS="-I$(PREFIX)/$(TARGET)/include" \

    # 	--prefix='$(PREFIX)/$(TARGET)'
    #    --host=x86_64-w64-mingw32
    #    --build=x86_64-pc-linux-gnu

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
