#!/bin/sh

# shellcheck disable=SC2006

setup_test() {
  return 0
}

shutdown_test() {
  return 0
}

before_each_test() {
  return 0
}

after_each_test() {
  return 0
}

test_get_system_arch() {
  _result=`get_system_arch`
  assert_equals "${_result}" "${SYSTEM_ARCH}"
}
