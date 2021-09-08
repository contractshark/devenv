#!/bin/sh

brew update
brew install pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
exec $SHELL

env PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install 3.8.11
