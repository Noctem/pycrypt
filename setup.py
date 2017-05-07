#!/usr/bin/env python

from os import environ
from setuptools import setup, Extension
from sys import platform

args = None

if platform != 'win32':
    args = ['-O3']
    if 'TRAVIS' not in environ:
        args.append('-march=native')

try:
    from Cython.Build import cythonize
    file_ext = 'pyx'
except ImportError:
    file_ext = 'cpp'

ext = [Extension("pycrypt",
                 sources=['pycrypt.' + file_ext,
                          'twofish.c'],
                 extra_compile_args=args,
                 extra_link_args=args,
                 language='c')]

if file_ext == 'pyx':
    ext = cythonize(ext)

setup (name='pycrypt',
       version='0.7',
       description='Fast TwoFish encryption.',
       long_description='A fast C extension for TwoFish encryption in Python.',
       url='https://github.com/Noctem/pycrypt',
       author='David Christenson',
       author_email='mail@noctem.xyz',
       license='MIT',
       classifiers=[
           'Development Status :: 4 - Beta',
           'Intended Audience :: Developers',
           'Programming Language :: Cython',
           'Programming Language :: Python :: 2',
           'Programming Language :: Python :: 2.7',
           'Programming Language :: Python :: 3',
           'Programming Language :: Python :: 3.3',
           'Programming Language :: Python :: 3.4',
           'Programming Language :: Python :: 3.5',
           'Programming Language :: Python :: 3.6',
           'Topic :: Security :: Cryptography',
           'License :: OSI Approved :: MIT License'
       ],
       keywords='pycrypt twofish pogo encryption cython',
       ext_modules=ext)
