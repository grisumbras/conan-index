#!/bin/sh -l


set -e
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


conan config set general.request_timeout=600
conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan
# conan search '*' -r all -j packages.json
echo '$HOME='$HOME
echo '$GITHUB_WORKSPACE='$GITHUB_WORKSPACE
ls $HOME -la
echo ----
ls $GITHUB_WORKSPACE -la
