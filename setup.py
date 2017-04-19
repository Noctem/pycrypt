#!/usr/bin/env python

from setuptools import setup, Extension

try:
    from Cython.Build import cythonize

    ext = cythonize([
        Extension("pycrypt",
                  sources=['pycrypt.pyx',
                           'twofish.c'])])
except ImportError:
    ext = [Extension("pycrypt",
                     sources=["pycrypt.c",
                              "twofish.c"])]

setup (name = 'pycrypt',
       version = '0.6.1',
       description = 'Fast TwoFish encryption.',
       long_description = 'A fast C extension for TwoFish encryption in Python.',
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
       ext_modules = ext)
