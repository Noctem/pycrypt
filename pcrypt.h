#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "shuffle2.c"
#include "unshuffle.c"
#include "unshuffle2.c"

int encrypt(const char* input, size_t len, uint32_t ms, char** output, char version);
int decrypt(const char* input, size_t len, char** output);
