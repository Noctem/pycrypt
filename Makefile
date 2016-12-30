WIN32CC = i686-w64-mingw32-gcc
WIN64CC = x86_64-w64-mingw32-gcc
ARM32CC = arm-linux-gnueabihf-gcc
ARM64CC = aarch64-linux-gnu-gcc
BSDCC = clang
CC = gcc
CFLAGS += -std=c99 -shared -Wno-implicit-function-declaration -fPIC -O3
BSDFLAGS = $(CFLAGS) -Wno-bitwise-op-parentheses

cross: linux arm windows

windows: win32 win64

linux: linux32 linux64

arm: arm32 arm64

mac: mac32 mac64

bsd: bsd32 bsd64

win32: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(WIN32CC) $(CFLAGS) -o libpcrypt-windows-i686.dll pcrypt.c

win64: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(WIN64CC) $(CFLAGS) -lws2_32 -o libpcrypt-windows-x86-64.dll pcrypt.c

linux32: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(CC) $(CFLAGS) -m32 -o libpcrypt-linux-i386.so pcrypt.c

linux64: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(CC) $(CFLAGS) -m64 -o libpcrypt-linux-x86-64.so pcrypt.c

arm32: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(ARM32CC) $(CFLAGS) -o libpcrypt-linux-arm32.so pcrypt.c

arm64: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(ARM64CC) $(CFLAGS) -o libpcrypt-linux-arm64.so pcrypt.c

mac32: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(BSDCC) $(BSDFLAGS) -m32 -mmacosx-version-min=10.5 -o libpcrypt-macos-i386.dylib pcrypt.c

mac64: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(BSDCC) $(BSDFLAGS) -m64 -march=core2 -mmacosx-version-min=10.7 -o libpcrypt-macos-x86-64.dylib pcrypt.c

bsd32: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(BSDCC) $(BSDFLAGS) -m32 -o libpcrypt-freebsd-i386.so pcrypt.c

bsd64: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(BSDCC) $(BSDFLAGS) -m64 -o libpcrypt-freebsd-x86-64.so pcrypt.c

static: pcrypt.o shuffle2.o unshuffle.o unshuffle2.o
	$(AR) rc $@ $^
	$(AR) -s $@

clean:
	$(RM) -f *.o *.dll *.so *.dylib *.a
