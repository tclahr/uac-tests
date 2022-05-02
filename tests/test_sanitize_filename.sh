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

test_common_filename() {
  _result=`sanitize_filename "uac.log"`
  assert_equals "${_result}" "uac.log"
}

test_slash() {
  _result=`sanitize_filename "/var/log/uac.log"`
  assert_equals "${_result}" "var_log_uac.log"
}

test_dot_dot_slash() {
  _result=`sanitize_filename "/../../uac.log"`
  assert_equals "${_result}" ".._.._uac.log"
}

test_double_slash() {
  _result=`sanitize_filename "//var//log//uac.log"`
  assert_equals "${_result}" "var_log_uac.log"
}

test_remove_leading_and_trailing_white_spaces() {
  _result=`sanitize_filename "   uac.log   "`
  assert_equals "${_result}" "uac.log"
}

test_empty_filename() {
  _result=`sanitize_filename ""`
  assert_equals "${_result}" ""
}