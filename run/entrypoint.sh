#!/bin/sh -l


set -e
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


mkdir -p build
conan search '*' -r conan-center > build
