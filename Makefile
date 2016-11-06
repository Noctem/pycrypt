WIN32CC = i686-w64-mingw32-gcc
WIN64CC = x86_64-w64-mingw32-gcc
CC = gcc
CFLAGS += -std=c99 -shared

all: encrypt32.dll encrypt64.dll libencrypt-linux-x86-64.so libencrypt-linux-x86-32.so

encrypt32.dll: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(WIN32CC) $(CFLAGS) -o encrypt32.dll pcrypt.c -lws2_32

encrypt64.dll: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(WIN64CC) $(CFLAGS) -o encrypt64.dll pcrypt.c -lws2_32

libencrypt-linux-x86-64.so: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(CC) $(CFLAGS) -m64 -fPIC -o libencrypt-linux-x86-64.so pcrypt.c
    
libencrypt-linux-x86-32.so: pcrypt.c shuffle2.c unshuffle.c unshuffle2.c
	$(CC) $(CFLAGS) -m32 -fPIC -o libencrypt-linux-x86-32.so pcrypt.c

clean:
	$(RM) -f *.o *.dll *.so