#!/usr/bin/env bash

set -e

macbuild() {
	pip3 install -U twine setuptools wheel
	rm -rf dist build
	if [[ "$1" = "sdist" && "$SOURCE" = TRUE ]]; then
		python3 setup.py sdist bdist_wheel
	else
		python3 setup.py bdist_wheel
	fi
	python3 setup.py install
	python3 test.py
	if [[ "$1" = "sdist" && "$SOURCE" = TRUE ]]; then
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
	macbuild sdist
	echo "Successfully uploaded Python 3.6 wheel and source."

	cd travis
	brew uninstall python3
	brew install python35.rb
	cd ..
	echo "Successfully installed Python 3.5."

	pip3 install -U twine
	macbuild
	echo "Successfully uploaded Python 3.5 wheel."
fi
