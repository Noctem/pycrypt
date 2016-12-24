WIN32CC = i686-w64-mingw32-gcc
WIN64CC = x86_64-w64-mingw32-gcc
CC = gcc
CFLAGS += -std=c99 -shared -O3

all: libpcrypt-windows-i686.dll libpcrypt-windows-x86-64.dll libpcrypt-linux-x86-64.so libpcrypt-linux-i386.so

libpcrypt-windows-i686.dll: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(WIN32CC) $(CFLAGS) -o libpcrypt-windows-i686.dll pcrypt.c -lws2_32

libpcrypt-windows-x86-64.dll: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(WIN64CC) $(CFLAGS) -o libpcrypt-windows-x86-64.dll pcrypt.c -lws2_32

libpcrypt-linux-x86-64.so: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(CC) $(CFLAGS) -m64 -fPIC -o libpcrypt-linux-x86-64.so pcrypt.c
    
libpcrypt-linux-i386.so: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(CC) $(CFLAGS) -m32 -fPIC -o libpcrypt-linux-i386.so pcrypt.c

clean:
	$(RM) -f *.o *.dll *.so