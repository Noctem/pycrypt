#!/usr/bin/env bash

set -e -x

# Compile wheels
for PYBIN in /opt/python/cp*/bin; do
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done

# Install packages
for PYBIN in /opt/python/cp*/bin/; do
    "${PYBIN}/pip" install pycrypt --no-index -f /io/wheelhouse
done
