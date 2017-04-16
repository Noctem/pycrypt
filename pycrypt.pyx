#!python
#cython: language_level=3

from libc.string cimport memcpy, memset
from libc.stdlib cimport exit
from libc.stdio cimport printf

from cpython cimport PyBytes_AsStringAndSize
from cpython.mem cimport PyMem_Malloc, PyMem_Free

from twofish cimport Twofish_Byte, Twofish_UInt32, Twofish_key, Twofish_initialise, Twofish_prepare_key, Twofish_encrypt


DEF BLOCK_SIZE = 16
DEF INTEGRITY_BYTE = 0x21
DEF KEY_SIZE = 32

cdef Twofish_key KEY


initialize()


cdef public void Twofish_fatal(char* msg):
    printf('%s\n', msg);
    exit(1)


cdef void initialize():
    cdef Twofish_Byte enc_key[KEY_SIZE]
    enc_key[:] = [
        0x4F, 0xEB, 0x1C, 0xA5, 0xF6, 0x1A, 0x67, 0xCE, 0x43, 0xF3, 0xF0,
        0x0C, 0xB1, 0x23, 0x88, 0x35, 0xE9, 0x8B, 0xE8, 0x39, 0xD8, 0x89,
        0x8F, 0x5A, 0x3B, 0x51, 0x2E, 0xA9, 0x47, 0x38, 0xC4, 0x14
    ]
    Twofish_initialise()
    Twofish_prepare_key(enc_key, KEY_SIZE, &KEY)


def pycrypt(bytes input_, Twofish_UInt32 iv):
    cdef Twofish_Byte xor_byte[BLOCK_SIZE]
    cdef Twofish_Byte i, block_count
    cdef unsigned short offset, output_size

    cdef Py_ssize_t length
    cdef char* plaintext
    PyBytes_AsStringAndSize(input_, &plaintext, &length)

    cdef Twofish_UInt32 state = iv

    for i in range(BLOCK_SIZE):
        state = (0x41C64E6D * state) + 0x3039
        xor_byte[i] = (state >> 16) & 0x7FFF

    block_count = (length + 256) // 256
    output_size = 4 + (block_count * 256) + 1

    cdef Twofish_Byte* output = <Twofish_Byte*> PyMem_Malloc(output_size)

    output[0] = iv >> 24
    output[1] = iv >> 16
    output[2] = iv >> 8
    output[3] = iv
    memcpy(output + 4, plaintext, length);
    memset(output + 4 + length, 0, 256 - length % 256)
    output[output_size - 2] = 256 - length % 256

    for offset in range(0, block_count * 256, BLOCK_SIZE):
        for i in range(BLOCK_SIZE):
            output[4 + offset + i] ^= xor_byte[i]

        Twofish_encrypt(&KEY, output + 4 + offset, output + 4 + offset)
        memcpy(xor_byte, output + 4 + offset, BLOCK_SIZE)

    output[output_size - 1] = INTEGRITY_BYTE

    cdef bytes encrypted = output[:output_size]
    PyMem_Free(output)
    return encrypted
