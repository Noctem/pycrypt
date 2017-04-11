#define PY_SSIZE_T_CLEAN

#include <Python.h>
#include "twofish.h"
#ifdef _WIN32
#include <malloc.h>
#endif

#define BLOCK_SIZE 16
#define INTEGRITY_BYTE 0x21
#define KEY_SIZE 32
#if PY_MAJOR_VERSION >= 3
#define ARG_TYPES "y#I"
#else
#define ARG_TYPES "s#I"
#endif

Twofish_key KEY;

static PyObject *pycrypt(PyObject *self, PyObject *args) {
  const char *input;
  Py_ssize_t len;
  Twofish_UInt32 ms, state;

  Twofish_Byte xor_byte[BLOCK_SIZE], i, block_count;
  unsigned short offset, output_size;
#ifdef _WIN32
  Twofish_Byte *output;
  PyObject *output_bytes;
#endif

  if (!PyArg_ParseTuple(args, ARG_TYPES, &input, &len, &ms)) {
    return NULL;
  }

  state = ms;

  for (i = 0; i < BLOCK_SIZE; ++i) {
    state = (0x41C64E6D * state) + 0x3039;
    xor_byte[i] = (state >> 16) & 0x7FFF;
  }

  block_count = (len + 256) / 256;
  output_size = 4 + (block_count * 256) + 1;

#ifdef _WIN32
  output = (Twofish_Byte *)_malloca(output_size);
#else
  Twofish_Byte output[output_size];
#endif

  output[0] = (ms >> 24);
  output[1] = (ms >> 16);
  output[2] = (ms >> 8);
  output[3] = ms;
  memcpy(output + 4, input, len);
  memset(output + 4 + len, 0, 256 - len % 256);
  output[output_size - 2] = (Twofish_Byte)(256 - len % 256);

  for (offset = 0; offset < block_count * 256; offset += BLOCK_SIZE) {
    for (i = 0; i < BLOCK_SIZE; i++)
      output[4 + offset + i] ^= xor_byte[i];

    Twofish_encrypt(&KEY, output + 4 + offset, output + 4 + offset);

    memcpy(xor_byte, output + 4 + offset, BLOCK_SIZE);
  }

  output[output_size - 1] = INTEGRITY_BYTE;

#ifdef _WIN32
  output_bytes = PyBytes_FromStringAndSize((char *)output, output_size);
  _freea(output);
  return output_bytes;
#else
  return PyBytes_FromStringAndSize((char *)output, output_size);
#endif
}

/* List of functions defined in the module */
static PyMethodDef PycryptMethods[] = {
    {"pycrypt", pycrypt, METH_VARARGS, "TwoFish encryption."},
    {NULL, NULL, 0, NULL} /* sentinel */
};

#if PY_MAJOR_VERSION >= 3
static struct PyModuleDef pycryptmodule = {
    PyModuleDef_HEAD_INIT, "pycrypt", /* name of module */
    NULL,                             /* module documentation, may be NULL */
    -1,                               /* size of per-interpreter state of the module,
                                         or -1 if the module keeps state in global variables. */
    PycryptMethods};

#define INITERROR return NULL

PyMODINIT_FUNC PyInit_pycrypt(void)
#else
#define INITERROR return

void initpycrypt(void)
#endif
{
  PyObject *module;
  Twofish_Byte enc_key[KEY_SIZE] = {
      0x4F, 0xEB, 0x1C, 0xA5, 0xF6, 0x1A, 0x67, 0xCE, 0x43, 0xF3, 0xF0,
      0x0C, 0xB1, 0x23, 0x88, 0x35, 0xE9, 0x8B, 0xE8, 0x39, 0xD8, 0x89,
      0x8F, 0x5A, 0x3B, 0x51, 0x2E, 0xA9, 0x47, 0x38, 0xC4, 0x14,
  };

  Twofish_initialise();
  Twofish_prepare_key(enc_key, KEY_SIZE, &KEY);

#if PY_MAJOR_VERSION >= 3
  module = PyModule_Create(&pycryptmodule);
#else
  module = Py_InitModule("pycrypt", PycryptMethods);
#endif

  if (module == NULL)
    INITERROR;
#if PY_MAJOR_VERSION >= 3
  return module;
#endif
}
