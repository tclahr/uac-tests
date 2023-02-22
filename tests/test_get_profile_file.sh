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

test_get_profile_file() {
  _result=`get_profile_file "full"`
  assert_equals "${_result}" "full.yaml"
}

test_get_invalid_profile_file() {
  _result=`get_profile_file "unknown"`
  assert_equals "${_result}" ""
}
