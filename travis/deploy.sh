#!/usr/bin/env bash

set -e

macbuild() {
	PYTHON="python${1}"
	PIP="pip${1}"
	"$PIP" install -U twine setuptools wheel
	rm -rf dist build
	if [[ "$2" = "sdist" && "$SOURCE" = TRUE ]]; then
		"$PYTHON" setup.py sdist bdist_wheel
	else
		"$PYTHON" setup.py bdist_wheel
	fi
	"$PYTHON" setup.py install
	"$PYTHON" test_pycrypt.py
	if [[ "$2" = "sdist" && "$SOURCE" = TRUE ]]; then
		twine upload --skip-existing --config-file .pypirc -r pypi dist/*.whl dist/*.tar.*
	else
		twine upload --skip-existing --config-file .pypirc -r pypi dist/*.whl
	fi
}

openssl aes-256-cbc -K "$encrypted_0a601b1cd6e7_key" -iv "$encrypted_0a601b1cd6e7_iv" -in travis/.pypirc.enc -out .pypirc -d

if [[ "$DOCKER_IMAGE" ]]; then
	pip3 install -U twine
	twine upload --skip-existing --config-file .pypirc -r pypi wheelhouse/*.whl
	echo "Successfully uploaded Linux wheels."
else
	macbuild 3 sdist
	echo "Successfully uploaded Python 3.6 wheel and source."

	brew install python
	macbuild 2

	cd travis
	brew uninstall python3
	brew install python35.rb
	cd ..
	echo "Successfully installed Python 3.5."

	macbuild 3
	echo "Successfully uploaded Python 3.5 wheel."
fi
