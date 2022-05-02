#!/bin/sh

# shellcheck disable=SC2006,SC2034

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

test_hostname_command() {
  MOUNT_POINT="/"
  _result=`get_hostname`
  assert_equals "${CURRENT_HOSTNAME}" "${_result}"
}

test_from_etc_hostname() {
  MOUNT_POINT="${TEMP_DIR}/mount_point"
  _result=`get_hostname`
  assert_equals "skeletor" "${_result}"
}
