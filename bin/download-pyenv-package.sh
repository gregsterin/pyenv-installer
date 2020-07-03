#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

RELEASE="v1.2.19"
PYENV_PACKAGE_ARCHIVE=
USE_HTTPS=

checkout() {
  [ -d "$2" ] && (cd "$2"; git clone "$1")
}

checkout_release() {
  [ -d "$2" ] && (cd "$2"; git clone -b "$RELEASE" "$1")
}

if [ -z "$PYENV_PACKAGE_ARCHIVE" ]; then
  PYENV_PACKAGE_ARCHIVE="$(cd $(dirname "$0") && pwd)/pyenv-package.tar.gz"
fi

TMP_DIR=$(mktemp -d)

if [ -n "${USE_HTTPS}" ]; then
  GITHUB="https://github.com"
else
  GITHUB="git://github.com"
fi

# checkout to temporary directory.
checkout_release "${GITHUB}/pyenv/pyenv.git"            "$TMP_DIR"
checkout         "${GITHUB}/pyenv/pyenv-doctor.git"     "$TMP_DIR"
checkout         "${GITHUB}/pyenv/pyenv-installer.git"  "$TMP_DIR"
checkout         "${GITHUB}/pyenv/pyenv-update.git"     "$TMP_DIR"
checkout         "${GITHUB}/pyenv/pyenv-virtualenv.git" "$TMP_DIR"
checkout         "${GITHUB}/pyenv/pyenv-which-ext.git"  "$TMP_DIR"

# create archive.
tar -zcf "$PYENV_PACKAGE_ARCHIVE" -C "$TMP_DIR" .

rm -rf $TMP_DIR
