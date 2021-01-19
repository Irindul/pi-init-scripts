#!/usr/bin/env bash
set -o errexit
set -o nounset

reset_term() {
  tput sgr0
}

echo_prefix() {
  local color=$1
  local symbol=$2
  echo -ne "["
  tput setaf "${color}"
  echo -ne "${symbol}"
  reset_term
  echo -ne "] - "
}

echo_ok() {
  echo_prefix 2 "*"
  echo "$@"
}

echo_err() {
  echo_prefix 1 "x"
  echo "$@"
} >&2 

echo_ok "Running installation script for Raspberry Pi <3"

exit 0
