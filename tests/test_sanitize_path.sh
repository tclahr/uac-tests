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

test_common_root_path() {
  _result=`sanitize_path "/"`
  assert_equals "${_result}" "/"
}

test_common_path() {
  _result=`sanitize_path "/var/log/uac.log"`
  assert_equals "${_result}" "/var/log/uac.log"
}

test_dot_dot_slash() {
  _result=`sanitize_path "/../../uac.log"`
  assert_equals "${_result}" "/../../uac.log"
}

test_double_slash() {
  _result=`sanitize_path "//var//log//uac.log"`
  assert_equals "${_result}" "/var/log/uac.log"
}

test_remove_leading_and_trailing_white_spaces() {
  _result=`sanitize_path "   /uac.log   "`
  assert_equals "${_result}" "/uac.log"
}

test_remote_trailing_slash() {
  _result=`sanitize_path "/var/log/"`
  assert_equals "${_result}" "/var/log"
}

test_double_quotes() {
  _result=`sanitize_path '"/var""/log"'`
  assert_equals "${_result}" '"/var""/log"'
}

test_empty_path() {
  _result=`sanitize_path ""`
  assert_equals "${_result}" "/"
}