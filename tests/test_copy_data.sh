#!/bin/sh

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_copy_data"
  mkdir -p "${TEMP_DATA_DIR}"

  echo "${MOUNT_POINT}/etc/issue" >>"${TEMP_DATA_DIR}/source_file.txt"
  echo "${MOUNT_POINT}/etc/default/keyboard" >>"${TEMP_DATA_DIR}/source_file.txt"
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

test_valid_source_file () {
  assert "copy_data \"${TEMP_DATA_DIR}/source_file.txt\" \"${TEMP_DATA_DIR}\""
}

test_invalid_source_file () { 
  assert_fails "copy_data \"${TEMP_DATA_DIR}/invalid_source_file.txt\" \"${TEMP_DATA_DIR}\""
}
