#!/usr/bin/env bash

set -e

macbuild() {
	PYTHON="python${1}"
	PIP="pip${1}"
	"$PIP" install -U setuptools wheel twine cython
	rm -rf dist build
	if [[ "$2" = "sdist" && "$SOURCE" = TRUE ]]; then
		"$PYTHON" setup.py sdist bdist_wheel
		"$PYTHON" setup.py install
		"$PYTHON" test_pycrypt.py
		twine upload --skip-existing dist/*.whl dist/*.tar.*
	else
		"$PYTHON" setup.py bdist_wheel
		"$PYTHON" setup.py install
		"$PYTHON" test_pycrypt.py
		twine upload --skip-existing dist/*.whl
	fi
}

if [[ "$DOCKER_IMAGE" ]]; then
	pip3 install -U twine
	twine upload --skip-existing wheelhouse/*.whl
	echo "Successfully uploaded Linux wheels."
else
	macbuild 3 sdist
	echo "Successfully uploaded Python 3.6 wheel and source."

	brew install python || brew upgrade python
	macbuild 2

	cd travis
	brew uninstall python3
	brew install https://raw.githubusercontent.com/Noctem/pogeo-toolchain/master/python35.rb
	cd ..
	echo "Successfully installed Python 3.5."

	macbuild 3
	echo "Successfully uploaded Python 3.5 wheel."
fi
