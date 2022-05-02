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

test_strip_one_white_space_on_the_left() {
  _result=`lrstrip " uac"`
  assert_equals "${_result}" "uac"
}

test_strip_one_white_space_on_the_right() {
  _result=`lrstrip "uac "`
  assert_equals "${_result}" "uac"
}

test_strip_multiple_white_spaces_on_the_left() {
  _result=`lrstrip "   uac"`
  assert_equals "${_result}" "uac"
}

test_strip_multiple_white_spaces_on_the_right() {
  _result=`lrstrip "uac   "`
  assert_equals "${_result}" "uac"
}

test_strip_multiple_white_spaces_on_both_sides() {
  _result=`lrstrip "   uac   "`
  assert_equals "${_result}" "uac"
}

test_strip_multiple_white_spaces_on_both_sides_word_with_white_spaces() {
  _result=`lrstrip "   u a c   "`
  assert_equals "${_result}" "u a c"
}
