#!/bin/sh -l


set -e
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


mkdir -p build
conan config set general.request_timeout=600
echo '!doctype html' >build/index.html
echo '<html><body><pre>' >>build/index.html
conan search '*' -r conan-center >>build/index.html
echo '</pre></body></html>' >>build/index.html
