#!/bin/sh

# shellcheck disable=SC2034

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_file_collector"
  mkdir -p "${TEMP_DATA_DIR}"
  UAC_LOG_FILE="${TEMP_DATA_DIR}/uac.log"

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

test_path() {
  file_collector \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "output_file.txt"
  assert_matches_file_content "${MOUNT_POINT}/etc/issue" "${TEMP_DATA_DIR}/output_file.txt"
}
