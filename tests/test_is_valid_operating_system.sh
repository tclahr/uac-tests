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

test_valid_operating_system() {
  assert "is_valid_operating_system \"linux\""
}

test_invalid_operating_system() {
  assert_fails "is_valid_operating_system \"invalid_os\""
}
