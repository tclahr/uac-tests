#!/bin/sh

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_create_acquisition_log"
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

test_create_acquisition_log_file() {
  assert "create_acquisition_log \"1234\" \"10\" \"description\" \"examiner\" \"notes\" \"hostname\" \"2020-01-01 00:00:00\" \"2020-01-01 23:59:59\" \"hash output_file\" \"${TEMP_DATA_DIR}\" \"acquisition.log\""
}

test_acquisition_log_file_exists() {
  assert_file_exists "${TEMP_DATA_DIR}/acquisition.log"
}

test_uac_version() {
  assert_matches_file_content "Created by .* ${UAC_VERSION}" "${TEMP_DATA_DIR}/acquisition.log"
}

test_case_number() {
  assert_matches_file_content "Case Number: 1234" "${TEMP_DATA_DIR}/acquisition.log"
}

test_evidence_number() {
  assert_matches_file_content "Evidence Number: 10" "${TEMP_DATA_DIR}/acquisition.log"
}

test_description() {
  assert_matches_file_content "Description: description" "${TEMP_DATA_DIR}/acquisition.log"
}

test_examiner() {
  assert_matches_file_content "Examiner: examiner" "${TEMP_DATA_DIR}/acquisition.log"
}

test_notes() {
  assert_matches_file_content "Notes: notes" "${TEMP_DATA_DIR}/acquisition.log"
}

test_operating_system() {
  assert_matches_file_content "Operating System: ${OPERATING_SYSTEM}" "${TEMP_DATA_DIR}/acquisition.log"
}

test_system_arch() {
  assert_matches_file_content "System Architecture: ${SYSTEM_ARCH}" "${TEMP_DATA_DIR}/acquisition.log"
}

test_hostname() {
  assert_matches_file_content "Hostname: hostname" "${TEMP_DATA_DIR}/acquisition.log"
}

test_mount_point() {
  assert_matches_file_content "Mount Point: ${MOUNT_POINT}" "${TEMP_DATA_DIR}/acquisition.log"
}

test_acquisition_started_at() {
  assert_matches_file_content "Acquisition started at: 2020-01-01 00:00:00" "${TEMP_DATA_DIR}/acquisition.log"
}

test_acquisition_finished_at() {
  assert_matches_file_content "Acquisition finished at: 2020-01-01 23:59:59" "${TEMP_DATA_DIR}/acquisition.log"
}

test_output_file_hash() {
  assert_matches_file_content "hash output_file" "${TEMP_DATA_DIR}/acquisition.log"
}