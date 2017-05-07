cdef extern from "twofish.h" nogil:
    ctypedef unsigned char Twofish_Byte
    ctypedef unsigned long Twofish_UInt32

    ctypedef struct Twofish_key:
        Twofish_UInt32 s[4][256]
        Twofish_UInt32 K[40]

    void Twofish_initialise()

    void Twofish_prepare_key(Twofish_Byte key[], int key_len,
                             Twofish_key *xkey)

    void Twofish_encrypt(Twofish_key *xkey, Twofish_Byte p[16],
                         Twofish_Byte c[16])
