#!/usr/bin/env bash

pip3 install twine
twine upload -u 'Noctem' -p "$PASS" --repository 'https://pypi.python.org/pypi' --skip-existing wheelhouse/*.whl

