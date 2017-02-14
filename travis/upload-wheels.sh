#!/usr/bin/env bash

pip3 install twine
twine -u 'Noctem' -p "$PASS" -r https://pypi.python.org/pypi wheelhouse/*.whl

