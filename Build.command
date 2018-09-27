#!/bin/sh

set -e

export PATH=${PATH}:/usr/local/bin
export LC_ALL="en_US.UTF-8"

function checkInstalledOrInstall {
  local name=$1
  local check=$2
  local install_command=$3

  echo "--- 👮  Checking ${name} is installed... \c"
  if [ -z "${check}" ]; then
    echo "could not find ${name}."
  	echo "--- 📦  Installing ${name}... \c"
    eval $install_command
    echo "done."
  else
    echo "👍"
  fi
}

function checkInstalledOrFail {
  local name=$1
  local check=$2
  local fail_message=$3

  echo "--- 👮  Checking ${name} is installed... \c"
  if [ -z "${check}" ]; then
    echo "could not find ${name}."
    echo "${fail_message}"
    exit 1
  else
    echo "👍"
  fi
}

echo "--- 🕵  Checking for and installing required dependencies"

checkInstalledOrFail "Homebrew" "$(which brew)" "--- 🚫  Stopping. Homebrew could not be found! Please install it from http://brew.sh"
checkInstalledOrInstall "acpica" "$(which acpica)" "brew install acpica --quiet"

echo "--- 📁  Creating output build directory"

mkdir -p Build

echo "--- 🛠  Compiling DSLs to AML"

find . -name "*.dsl" -type f -exec sh -c 'f=$(basename $0 .dsl); iasl -p "Build/$f.aml" "$f.dsl"' {} \;

echo "--- ✅  Done! Copy the AML files required from within the 'Build' directory"
