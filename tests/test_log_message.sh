#!/bin/sh

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_log_message"
  mkdir -p "${TEMP_DATA_DIR}"
  UAC_LOG_FILE="${TEMP_DATA_DIR}/uac.log"
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

test_command_log_message() {
  assert "log_message COMMAND \"command log message\""
}

test_debug_log_message() {
  assert "log_message DEBUG \"debug log message\""
}

test_info_log_message() {
  assert "log_message INFO \"info log message\""
}

test_warning_log_message() {
  assert "log_message WARNING \"warning log message\""
}

test_error_log_message() {
  assert "log_message ERROR \"error log message\""
}

test_invalid_level() {
  assert "log_message INVALID \"info log message\""
}

test_message_exist_in_log_file() {
  assert_matches_file_content "^[1|2][0-9]{3,3}\-[0-9]{2,2}\-[0-9]{2,2} [0-9]{2,2}:[0-9]{2,2}:[0-9]{2,2} .* COMMAND command log message" "${UAC_LOG_FILE}"
}