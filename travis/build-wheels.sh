#!/usr/bin/env bash

set -e -x

export TRAVIS=true

# Compile wheels
for PIP in /opt/python/cp*/bin/pip; do
	"$PIP" install -U cython
	"$PIP" wheel -v /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
	auditwheel repair "$whl" -w /io/wheelhouse/ || auditwheel -v show "$WHL"
done

# Install packages and test
for PYBIN in /opt/python/cp*/bin/; do
	"${PYBIN}/pip" install pycrypt --no-index -f /io/wheelhouse
	"${PYBIN}/python" /io/test_pycrypt.py
done
