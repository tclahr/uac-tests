#!/bin/sh

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_parse_artifact_list"
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

test_parse_artifact_list() {
  assert "parse_artifact_list \"live_response/process/ps.yaml,live_response/process/lsof.yaml,live_response/process/*,!bodyfile/bodyfile.yaml,chkrootkit/*.yaml,!live_response/process/lsof.yaml,live_response/process/lsof.yaml,hash_executables/hash_executables.yaml,\" >\"${TEMP_DATA_DIR}/.artifacts.tmp\""
}

test_artifact_added() {
  assert_matches_file_content "live_response/process/ps.yaml" "${TEMP_DATA_DIR}/.artifacts.tmp"
}

test_artifact_excluded_and_added() {
  assert_matches_file_content "live_response/process/lsof.yaml" "${TEMP_DATA_DIR}/.artifacts.tmp"
}

test_wildcard_added() {
  assert_matches_file_content "live_response/process/deleted.yaml" "${TEMP_DATA_DIR}/.artifacts.tmp"
}

test_skip_artifact() {
  assert_not_matches_file_content "bodyfile/bodyfile.yaml" "${TEMP_DATA_DIR}/.artifacts.tmp"
}