#!/usr/bin/env python

try:
    from setuptools import setup, Extension
except ImportError:
    from distutils.core import setup, Extension

from sys import platform

if platform == 'win32':
    extra_args = []
else:
    extra_args = ['-std=c99', '-Wno-implicit-function-declaration', '-O3']
    if platform == 'darwin':
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
       version = '0.1.1',
       description = 'Fast pogo encryption.',
       long_description = 'A fast C extension for Pogo encryption in Python.',
       url='https://github.com/Noctem/pycrypt',
       author='David Christenson',
       author_email='mail@noctem.xyz',
       classifiers=[
           'Development Status :: 4 - Beta',
           'Intended Audience :: Developers',
           'Operating System :: OS Independent',
           'Programming Language :: C',
           'Programming Language :: Python :: 3',
           'Programming Language :: Python :: 3.4',
           'Programming Language :: Python :: 3.5',
           'Programming Language :: Python :: 3.6',
           'Topic :: Security :: Cryptography',
       ],
       keywords='pycrypt pcrypt pogo encryption',
       ext_modules = [pycrypt])
