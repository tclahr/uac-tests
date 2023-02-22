#!/bin/sh

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_artifact_file_exist"
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

test_artifact_file_exist() {
  assert "artifact_file_exist \"live_response/process/ps.yaml\""
}

test_artifact_file_exist_leading_slash() {
  assert "artifact_file_exist \"/live_response/process/ps.yaml\""
}

test_artifact_file_not_exist() {
  assert_fails "artifact_file_exist \"live_response/process/ps1.yaml\""
}
