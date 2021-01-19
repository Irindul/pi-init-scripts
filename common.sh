#!/usr/bin/env bash

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

echo_info() {
  echo_prefix 3 "*"
  echo "$@"
}

echo_prompt() {
    echo_prefix 5 ">"
    echo "$@"
}

echo_err() {
  echo_prefix 1 "x"
  echo "$@"
} >&2 