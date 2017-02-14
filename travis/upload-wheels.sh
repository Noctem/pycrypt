#!/usr/bin/env bash

pip3 install twine
twine upload --config-file .pypirc -r pypi wheelhouse/*.whl
