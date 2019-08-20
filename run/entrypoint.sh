#!/bin/sh -l


set -e
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


mkdir -p build
conan config set general.request_timeout 600
conan search '*' -r conan-center > build/1.txt
