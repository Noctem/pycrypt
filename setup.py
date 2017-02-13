try:
    from setuptools import setup, Extension
except ImportError:
    from distutils.core import setup, Extension

from sys import platform

extra_args = ['-std=c99', '-Wno-implicit-function-declaration', '-O3']

if platform == 'win32':
    extra_args.append('-lws2_32')
elif platform == 'darwin':
    extra_args.append('-Wno-bitwise-op-parentheses')

pycrypt = Extension('pycrypt',
                  extra_compile_args = extra_args,
                  extra_link_args = extra_args,
                  sources = [
                      'pycrypt.c',
                      'shuffle2.c'
                  ],
                  language='c')

setup (name = 'pycrypt',
       version = '0.1',
       description = 'pcrypt-c Python extension.',
       ext_modules = [pycrypt])
