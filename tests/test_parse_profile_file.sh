#!/bin/sh

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_parse_profile_file"
  mkdir -p "${TEMP_DATA_DIR}"

  cat << EOF >"${TEMP_DATA_DIR}/full.yaml"
name: full
description: Full artifacts collection.
artifacts:
  - live_response/process/ps.yaml
  - live_response/process/lsof.yaml
  - live_response/process/top.yaml
  - live_response/process/procfs_information.yaml
  - live_response/process/*
  - live_response/system/*
  - !bodyfile/bodyfile.yaml
  - chkrootkit/chkrootkit.yaml
  - hash_executables/hash_executables.yaml
EOF
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

test_parse_profile_file() {
  assert "parse_profile_file \"${TEMP_DATA_DIR}/full.yaml\""
}

test_artifact_added() {
  assert_matches_file_content "live_response/process/ps.yaml" "${TEMP_DATA_DIR}/.artifacts.tmp"
}

test_wildcard_added() {
  assert_matches_file_content "live_response/process/deleted.yaml" "${TEMP_DATA_DIR}/.artifacts.tmp"
}

test_skip_artifact() {
  assert_not_matches_file_content "bodyfile/bodyfile.yaml" "${TEMP_DATA_DIR}/.artifacts.tmp"
}