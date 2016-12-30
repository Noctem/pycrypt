#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
  #include <winsock2.h>
#else
  #include <arpa/inet.h>
#endif
#include "shuffle2.c"
#include "unshuffle.c"
#include "unshuffle2.c"

#ifdef _WIN32
  #define EXPORT __declspec(dllexport)
#else
  #define EXPORT extern
#endif

EXPORT int encrypt(const char* input, size_t len, uint32_t ms, char** output);
EXPORT int decrypt(const char* input, size_t len, char** output);
