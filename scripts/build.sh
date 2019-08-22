#!/bin/bash

PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

mkdir -p build

export TRAVIS_TAG="v${PACKAGE_VERSION}"

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
  make -f makefile.darwin
  OS="darwin"
else
  make -f makefile.linux
  OS="linux"
  zip -r "build/electron-launcher-${TRAVIS_TAG}-${OS}-ia32.zip" "build/electron-launcher"

  # TODO: I need help with it, Travis keeps throwing `ERROR: Could not invoke sanity test executable`
  # make -f makefile.win32 clean
  # make -f makefile.win32
  # OS="win32"
  # zip -r "build/electron-launcher-${TRAVIS_TAG}-${OS}-ia32.zip" "build/electron-launcher.exe"
fi
