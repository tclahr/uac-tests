#!/bin/sh

# shellcheck disable=SC2006

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_profile_file_to_artifact_list"
  mkdir -p "${TEMP_DATA_DIR}"

  cat << EOF >"${TEMP_DATA_DIR}/full.yaml"
name: full
description: Full artifacts collection.
artifacts:
  - live_response/process/ps.yaml
  - live_response/process/lsof.yaml
  - live_response/process/*
  - !bodyfile/bodyfile.yaml
  - chkrootkit/*.yaml
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

test_profile_file_to_artifact_list() {
  assert "profile_file_to_artifact_list \"${TEMP_DATA_DIR}/full.yaml\""
}

test_artifact_list() {
  _result=`profile_file_to_artifact_list "${TEMP_DATA_DIR}/full.yaml"`
  assert_equals "live_response/process/ps.yaml,live_response/process/lsof.yaml,live_response/process/*,!bodyfile/bodyfile.yaml,chkrootkit/*.yaml,hash_executables/hash_executables.yaml," "${_result}"
}
