#!/bin/sh

MY_PATH="$( dirname "$0" )"
DIR="$( cd "${MY_PATH}" && pwd )"  # absolutized and normalized

cd "${DIR}"

ansible-playbook -i localhost, ./create_test.yml
