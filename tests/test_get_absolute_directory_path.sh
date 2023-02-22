#!/bin/sh

# shellcheck disable=SC2006

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_get_absolute_directory_path"
  mkdir -p "${TEMP_DATA_DIR}"
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

test_get_absolute_directory_path() {
  assert "get_absolute_directory_path \"${TEMP_DATA_DIR}\""
}

test_get_valid_absolute_directory_path() {
  _result=`get_absolute_directory_path "${TEMP_DATA_DIR}"`
  assert_equals "${_result}" "${TEMP_DATA_DIR}"
}

test_get_dot_dot_absolute_directory_path() {
  _result=`get_absolute_directory_path "../../../../../../../../${TEMP_DATA_DIR}"`
  assert_equals "${_result}" "${TEMP_DATA_DIR}"
}

test_get_invalid_dot_dot_absolute_directory_path() {
  _result=`get_absolute_directory_path "../../../../../../../../invalid_path/${TEMP_DATA_DIR}"`
  assert_not_equals "${_result}" "${TEMP_DATA_DIR}"
}