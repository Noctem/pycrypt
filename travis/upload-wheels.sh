#!/usr/bin/env bash

pip3 install twine
twine upload -u 'Noctem' -p "$PASS" wheelhouse/*.whl

