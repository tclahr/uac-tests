#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/create_acquisition_log.sh"

  _hash_file()
  {
    printf "HASH_FILE"
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_create_acquisition_log"
 
  mkdir -p "${__TEST_TEMP_DIR}"
  __UAC_DESTINATION_DIR="${__TEST_TEMP_DIR}"

}

setUp()
{
  __UAC_VERSION="UAC_VERSION"
  __UAC_CASE_NUMBER="CASE_NUMBER"
  __UAC_EVIDENCE_NUMBER="EVIDENCE_NUMBER"
  __UAC_EVIDENCE_DESCRIPTION="EVIDENCE_DESCRIPTION"
  __UAC_EXAMINER="EXAMINER"
  __UAC_EVIDENCE_NOTES="EVIDENCE_NOTES"
  __UAC_OPERATING_SYSTEM="OPERATING_SYSTEM"
  __UAC_SYSTEM_ARCH="SYSTEM_ARCH"
  __UAC_HOSTNAME="HOSTNAME"
  __UAC_MOUNT_POINT="MOUNT_POINT"
  __UAC_OUTPUT_FORMAT="OUTPUT_FORMAT"
  __UAC_OUTPUT_BASE_NAME="OUTPUT_BASE_NAME"
  __UAC_OUTPUT_EXTENSION="OUTPUT_EXTENSION"
  __UAC_OUTPUT_PASSWORD=""
  __UAC_CONF_HASH_ALGORITHM="md5|sha256"
}

test_create_acquisition_log_success()
{
  _create_acquisition_log \
    "${__TEST_TEMP_DIR}/create_acquisition_log_success.log" \
    "START_DATE" \
    "END_DATE" \
    "md5 checksum: HASH_FILE
sha256 checksum: HASH_FILE"

  __test_actual=`cat "${__TEST_TEMP_DIR}/create_acquisition_log_success.log"`
  assertEquals "Created by UAC (Unix-like Artifacts Collector) UAC_VERSION

[Case Information]
Case Number: CASE_NUMBER
Evidence Number: EVIDENCE_NUMBER
Description: EVIDENCE_DESCRIPTION
Examiner: EXAMINER
Notes: EVIDENCE_NOTES

[System Information]
Operating System: OPERATING_SYSTEM
System Architecture: SYSTEM_ARCH
Hostname: HOSTNAME

[Acquisition Information]
Mount Point: MOUNT_POINT
Acquisition Started: START_DATE
Acquisition Finished: END_DATE

[Output Information]
File: OUTPUT_BASE_NAME.OUTPUT_EXTENSION
Format: OUTPUT_FORMAT

[Computed Hashes]
md5 checksum: HASH_FILE
sha256 checksum: HASH_FILE" "${__test_actual}"

}

test_create_acquisition_log_output_format_none_success()
{
  __UAC_OUTPUT_FORMAT="none"

  _create_acquisition_log \
    "${__TEST_TEMP_DIR}/create_acquisition_log_output_format_none_success.log" \
    "START_DATE" \
    "END_DATE" \
    "md5 checksum: HASH_FILE
sha256 checksum: HASH_FILE"

  __test_actual=`cat "${__TEST_TEMP_DIR}/create_acquisition_log_output_format_none_success.log"`
  assertEquals "Created by UAC (Unix-like Artifacts Collector) UAC_VERSION

[Case Information]
Case Number: CASE_NUMBER
Evidence Number: EVIDENCE_NUMBER
Description: EVIDENCE_DESCRIPTION
Examiner: EXAMINER
Notes: EVIDENCE_NOTES

[System Information]
Operating System: OPERATING_SYSTEM
System Architecture: SYSTEM_ARCH
Hostname: HOSTNAME

[Acquisition Information]
Mount Point: MOUNT_POINT
Acquisition Started: START_DATE
Acquisition Finished: END_DATE

[Output Information]
Directory: OUTPUT_BASE_NAME
Format: none" "${__test_actual}"

}

test_create_acquisition_log_output_format_zip_success()
{
  __UAC_OUTPUT_FORMAT="zip"

  _create_acquisition_log \
    "${__TEST_TEMP_DIR}/create_acquisition_log_output_format_zip_success.log" \
    "START_DATE" \
    "END_DATE" \
    "md5 checksum: HASH_FILE
sha256 checksum: HASH_FILE"

  __test_actual=`cat "${__TEST_TEMP_DIR}/create_acquisition_log_output_format_zip_success.log"`
  assertEquals "Created by UAC (Unix-like Artifacts Collector) UAC_VERSION

[Case Information]
Case Number: CASE_NUMBER
Evidence Number: EVIDENCE_NUMBER
Description: EVIDENCE_DESCRIPTION
Examiner: EXAMINER
Notes: EVIDENCE_NOTES

[System Information]
Operating System: OPERATING_SYSTEM
System Architecture: SYSTEM_ARCH
Hostname: HOSTNAME

[Acquisition Information]
Mount Point: MOUNT_POINT
Acquisition Started: START_DATE
Acquisition Finished: END_DATE

[Output Information]
File: OUTPUT_BASE_NAME.OUTPUT_EXTENSION
Format: zip

[Computed Hashes]
md5 checksum: HASH_FILE
sha256 checksum: HASH_FILE" "${__test_actual}"

}

test_create_acquisition_log_zip_password_success()
{
  __UAC_OUTPUT_FORMAT="zip"
  __UAC_OUTPUT_PASSWORD="OUTPUT_PASSWORD"

  _create_acquisition_log \
    "${__TEST_TEMP_DIR}/create_acquisition_log_zip_password_success.log" \
    "START_DATE" \
    "END_DATE" \
    "md5 checksum: HASH_FILE
sha256 checksum: HASH_FILE"

  __test_actual=`cat "${__TEST_TEMP_DIR}/create_acquisition_log_zip_password_success.log"`
  assertEquals "Created by UAC (Unix-like Artifacts Collector) UAC_VERSION

[Case Information]
Case Number: CASE_NUMBER
Evidence Number: EVIDENCE_NUMBER
Description: EVIDENCE_DESCRIPTION
Examiner: EXAMINER
Notes: EVIDENCE_NOTES

[System Information]
Operating System: OPERATING_SYSTEM
System Architecture: SYSTEM_ARCH
Hostname: HOSTNAME

[Acquisition Information]
Mount Point: MOUNT_POINT
Acquisition Started: START_DATE
Acquisition Finished: END_DATE

[Output Information]
File: OUTPUT_BASE_NAME.OUTPUT_EXTENSION
Format: zip
Password: \"OUTPUT_PASSWORD\"

[Computed Hashes]
md5 checksum: HASH_FILE
sha256 checksum: HASH_FILE" "${__test_actual}"

}