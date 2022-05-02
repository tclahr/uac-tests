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

test_is_integer() {
  assert "is_integer 100"
}

test_fails_if_float() {
  assert_fails "is_integer 1.1"
}

test_not_integer() {
  assert_fails "is_integer uac"
}

test_empty_value() {
  assert_fails "is_integer"
}