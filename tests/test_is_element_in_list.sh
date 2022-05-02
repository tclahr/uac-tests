#!/bin/sh

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

test_one_element() {
  assert "is_element_in_list \"linux\" \"linux\""
}

test_three_elements_comma_space() {
  assert "is_element_in_list \"linux\" \"linux, aix, solaris\""
}

test_three_elements_comma_no_space() {
  assert "is_element_in_list \"aix\" \"linux,aix,solaris\""
}

test_three_elements_with_double_quotes() {
  assert "is_element_in_list \"linux\" '\"linux\", \"aix\", \"solaris\"'"
}

test_element_not_found() {
  assert_fails "is_element_in_list \"freebsd\" \"linux, aix, solaris\""
}

test_similar_element() {
  assert_fails "is_element_in_list \"aix\" \"linux, aixx, solaris\""
}

test_empty_list() {
  assert_fails "is_element_in_list \"aix\" \"\""
}