#!/usr/bin/env bash

pip3 install twine
twine upload -u 'Noctem' -p "$PASS" -r https://pypi.python.org/pypi wheelhouse/*.whl

