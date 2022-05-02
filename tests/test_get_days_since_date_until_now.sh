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

test_date_as_parameter() {
  assert "get_days_since_date_until_now 2022-01-01"
}

test_invalid_date_as_parameter() {
  assert_fails "get_days_since_date_until_now invalid"
}

test_fail_if_no_date_as_parameter() {
  assert_fails "get_days_since_date_until_now"
}
