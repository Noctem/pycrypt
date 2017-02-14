#!/usr/bin/env bash

pip3 install twine
twine upload -u 'Noctem' -p "$PASS" --repository-url https://pypi.python.org/pypi wheelhouse/*.whl

