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

test_empty_array() {
  _result=`array_to_list '[]'`
  assert_equals "${_result}" ""
}

test_empty_array_with_double_quotes() {
  _result=`array_to_list '[""]'`
  assert_equals "${_result}" ""
}

test_one_value() {
  _result=`array_to_list '[/etc]'`
  assert_equals "${_result}" "/etc"
}

test_one_value_with_double_quotes() {
  _result=`array_to_list '["/etc"]'`
  assert_equals "${_result}" "/etc"
}

test_two_values() {
  _result=`array_to_list '[/etc, /usr]'`
  assert_equals "${_result}" "/etc,/usr"
}

test_two_values_with_double_quotes() {
  _result=`array_to_list '[/etc, "/usr"]'`
  assert_equals "${_result}" "/etc,/usr"
}

test_empty_value_in_the_beginning() {
  _result=`array_to_list '[, , ,/etc,"/usr"]'`
  assert_equals "${_result}" "/etc,/usr"
}

test_empty_value_in_the_middle() {
  _result=`array_to_list '[/etc, , , "/usr"]'`
  assert_equals "${_result}" "/etc,/usr"
}

test_empty_value_in_the_end() {
  _result=`array_to_list '[/etc,"/usr", , ,]'`
  assert_equals "${_result}" "/etc,/usr"
}

test_value_with_comma() {
  _result=`array_to_list '[/e\,tc,"/u\,sr"]'`
  assert_equals "${_result}" "/e\,tc,/u\,sr"
}

test_value_with_special_characters() {
  _result=`array_to_list '["*.log", "*.[Ll][Oo][Gg]"]'`
  assert_equals "${_result}" "*.log,*.[Ll][Oo][Gg]"
}