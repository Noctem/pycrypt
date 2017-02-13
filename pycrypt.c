#define PY_SSIZE_T_CLEAN
#include <Python.h>

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

void shuffle2(uint32_t* vector);

#ifdef _WIN32
	typedef	unsigned char	u_char;

	uint32_t htonl(uint32_t x)
	{
		u_char *s = (u_char *)&x;
		return (uint32_t)(s[0] << 24 | s[1] << 16 | s[2] << 8 | s[3]);
	}
#endif

uint8_t rotl8(uint8_t val, uint8_t bits) {
	return ((val << bits) | (val >> (8 - bits))) & 0xff;
}

uint8_t gen_rand(uint32_t* rand) {
	*rand = *rand * 0x41c64e6d + 12345;
	return (*rand >> 16) & 0xff;
}

typedef struct cipher8_t {
	uint8_t cipher[256];
} cipher8_t;

cipher8_t cipher8_from_iv(uint8_t* iv) {
	cipher8_t cipher8;
	for (size_t ii = 0; ii < 8; ++ii) {
		for (size_t jj = 0; jj < 32; ++jj) {
			cipher8.cipher[32 * ii + jj] = rotl8(iv[jj], ii);
		}
	}
	return cipher8;
}

cipher8_t cipher8_from_rand(uint32_t* rand) {
	cipher8_t cipher8;
	for (size_t ii = 0; ii < 256; ++ii) {
		cipher8.cipher[ii] = gen_rand(rand);
	}
	return cipher8;
}

char make_integrity_byte1(char byte) {
	return byte & 0xf3 | 0x08;
}

char make_integrity_byte2(char byte) {
	return byte & 0xe3 | 0x10;
}

/**
 * input:    cleartext
 * ms:       seed for iv
 * version:  integrity byte version (2 or 3)
 * returns:  length of `output`
 */
static PyObject *pycrypt(PyObject *self, PyObject *args) {
	const char* input;
	Py_ssize_t len;
	uint32_t ms;
	unsigned char version;

	if (!PyArg_ParseTuple(args, "y#IB", &input, &len, &ms, &version)) {
		return NULL;
	}

	// Sanity checks
	if (len == 0) {
		return NULL;
	}

	// Allocate output space
	size_t rounded_size = len + (256 - (len % 256));
	size_t total_size = rounded_size + 5;
	char* encrypted = (char*)malloc(total_size + 3);
	uint8_t* output8 = (uint8_t*)encrypted;
	uint32_t* output32 = (uint32_t*)encrypted;

	// Write out seed
	output32[0] = htonl(ms);
	memcpy(output8 + 4, input, len);

	// Fill zeros + mark length
	if (rounded_size > len) {
		memset(output8 + 4 + len, 0, rounded_size - len);
	}
	output8[total_size - 2] = 256 - (len % 256);

	// Generate cipher and integrity byte
	cipher8_t cipher8_tmp = cipher8_from_rand(&ms);
	uint8_t* cipher8 = cipher8_tmp.cipher;
	uint32_t* cipher32 = (uint32_t*)cipher8;
	if (version == 2) {
		output8[total_size - 1] = make_integrity_byte1(gen_rand(&ms));
	} else {
		output8[total_size - 1] = make_integrity_byte2(gen_rand(&ms));
	}

	// Encrypt in chunks of 256 bytes
	for (size_t offset = 4; offset < total_size - 1; offset += 256) {
		for (size_t ii = 0; ii < 64; ++ii) {
			output32[offset / 4 + ii] ^= cipher32[ii];
		}
		shuffle2((uint32_t*)(output8 + offset));
		memcpy(cipher8, output8 + offset, 256);
	}
	PyObject *output_bytes;
	output_bytes = PyBytes_FromStringAndSize(encrypted, total_size);
	free(encrypted);
	return output_bytes;
}

/* List of functions defined in the module */
static PyMethodDef PycryptMethods[] = {
    {"pycrypt", pycrypt, METH_VARARGS,
     "U6 encryption."},
    {NULL, NULL, 0, NULL} /* sentinel */
};

static struct PyModuleDef pycryptmodule = {
    PyModuleDef_HEAD_INIT, "pycrypt", /* name of module */
    NULL,                             /* module documentation, may be NULL */
    -1, /* size of per-interpreter state of the module,
           or -1 if the module keeps state in global variables. */
    PycryptMethods
};

PyMODINIT_FUNC PyInit_pycrypt(void) { return PyModule_Create(&pycryptmodule); }
