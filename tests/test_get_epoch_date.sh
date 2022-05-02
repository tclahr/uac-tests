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

test_no_date_as_argument() {
  assert "get_epoch_date"
}

test_date_as_argument() {
  assert "get_epoch_date 2022-01-01"
}

test_invalid_date_as_argument() {
  assert_fails "get_epoch_date 3000-50-40"
}
