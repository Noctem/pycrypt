#!/usr/bin/env python

from sys import platform

from setuptools import setup, Extension

extra_args = [] if platform == 'win32' else ['-O3']

pycrypt = Extension('pycrypt',
                  extra_compile_args = extra_args,
                  extra_link_args = extra_args,
                  sources = [
                      'pycrypt.cpp',
                      'twofish.cpp'
                  ],
                  language='c++')

setup (name = 'pycrypt',
       version = '0.2.0b2',
       description = 'Fast TwoFish encryption.',
       long_description = 'A fast C extension for TwoFish encryption in Python.',
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
       keywords='pycrypt twofish pogo encryption',
       ext_modules = [pycrypt])
