#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2153,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/parse_command_line_arguments.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  _exit_success()
  {
    exit 0
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_parse_command_line_arguments"
  __UAC_DESTINATION_DIR="${__TEST_TEMP_DIR}"
  
}

test_parse_command_line_arguments_help_success()
{
  # stub
  _usage()
  {
    printf %b "help message"
  }

  __test_actual=`_parse_command_line_arguments -h`
  assertEquals "help message" "${__test_actual}"

  __test_actual=`_parse_command_line_arguments --help`
  assertEquals "help message" "${__test_actual}"
}

test_parse_command_line_arguments_version_success()
{
  # stub
  __UAC_VERSION="TEST"

  __test_actual=`_parse_command_line_arguments -V`
  assertEquals "UAC (Unix-like Artifacts Collector) TEST" "${__test_actual}"
  
  __test_actual=`_parse_command_line_arguments --version`
  assertEquals "UAC (Unix-like Artifacts Collector) TEST" "${__test_actual}"
}

test_parse_command_line_arguments_list_profiles_success()
{
  # stub
  __UAC_DIR="${__TEST_TEMP_DIR}"

  _list_profiles()
  {
    printf %b "list profiles"
  }

  __test_actual=`_parse_command_line_arguments -p list`
  assertEquals "list profiles" "${__test_actual}"

  __test_actual=`_parse_command_line_arguments --profile list`
  assertEquals "list profiles" "${__test_actual}"
}

test_parse_command_line_arguments_no_such_profile_name_fail()
{
  # stub
  __UAC_DIR="${__TEST_TEMP_DIR}"

  _get_profile_by_name()
  {
    printf %b ""
  }

  __test_actual=`_parse_command_line_arguments -p invalid 2>/dev/null`
  assertNull "${__test_actual}"
}

test_parse_command_line_arguments_list_artifacts_success()
{
  # stub
  __UAC_DIR="${__TEST_TEMP_DIR}"

  _list_artifacts()
  {
    printf %b "list artifacts"
  }

  __test_actual=`_parse_command_line_arguments -a list`
  echo "__test_actual: ${__test_actual}"
  assertEquals "list artifacts" "${__test_actual}"

  __test_actual=`_parse_command_line_arguments --artifacts list`
  echo "__test_actual: ${__test_actual}"
  assertEquals "list artifacts" "${__test_actual}"
}

test_parse_command_line_arguments_validate_artifact_success()
{
  # stub
  _validate_artifact()
  {
    return 0
  }

  assertTrue "_parse_command_line_arguments --validate-artifact artifact.yaml"
}

test_parse_command_line_arguments_validate_artifact_no_such_file_fail()
{
  # stub
  _validate_artifact()
  {
    return 1
  }

  assertFalse "_parse_command_line_arguments --validate-artifact"
}

test_parse_command_line_arguments_validate_profile_success()
{
  # stub
  _validate_profile()
  {
    return 0
  }

  assertTrue "_parse_command_line_arguments --validate-profile profile.yaml"
}

test_parse_command_line_arguments_validate_profile_no_such_file_fail()
{
  # stub
  _validate_profile()
  {
    return 1
  }

  assertFalse "_parse_command_line_arguments --validate-profile"
}

test_parse_command_line_arguments_artifact_list_success()
{
  # stub
  _parse_profile()
  {
    printf %b "live_response/process/ps.yaml,live_response/process/lsof.yaml,live_response/process/*,!bodyfile/bodyfile.yaml,files/*"
  }

  _get_profile_by_name()
  {
    printf %b "test"
  }

  _validate_profile()
  {
    return 0
  }

  __UAC_ARTIFACT_LIST=""
  _parse_command_line_arguments -p "${__TEST_TEMP_DIR}/profiles/test_profile01.yaml"
  assertEquals "live_response/process/ps.yaml,live_response/process/lsof.yaml,live_response/process/*,!bodyfile/bodyfile.yaml,files/*" "${__UAC_ARTIFACT_LIST}"
  
  __UAC_ARTIFACT_LIST=""
  _parse_command_line_arguments -a files/file01.yaml -p "${__TEST_TEMP_DIR}/profiles/test_profile01.yaml"
  assertEquals "files/file01.yaml,live_response/process/ps.yaml,live_response/process/lsof.yaml,live_response/process/*,!bodyfile/bodyfile.yaml,files/*" "${__UAC_ARTIFACT_LIST}"
  
  __UAC_ARTIFACT_LIST=""
  _parse_command_line_arguments -a files/file01.yaml -p "${__TEST_TEMP_DIR}/profiles/test_profile01.yaml" -a files/file02.yaml,files/file03.yaml
  assertEquals "files/file01.yaml,live_response/process/ps.yaml,live_response/process/lsof.yaml,live_response/process/*,!bodyfile/bodyfile.yaml,files/*,files/file02.yaml,files/file03.yaml" "${__UAC_ARTIFACT_LIST}"
}

test_parse_command_line_arguments_no_such_output_base_name_fail()
{
  assertFalse "_parse_command_line_arguments --output-base-name"
}

test_parse_command_line_arguments_output_base_name_success()
{
  __UAC_OUTPUT_BASE_NAME=""
  _parse_command_line_arguments --output-base-name "uac_%hostname%_%os%_%timestamp%"
  assertEquals "uac_%hostname%_%os%_%timestamp%" "${__UAC_OUTPUT_BASE_NAME}"
}

test_parse_command_line_arguments_no_such_output_format_fail()
{
  assertFalse "_parse_command_line_arguments --output-format"
}

test_parse_command_line_arguments_output_format_success()
{
  __UAC_OUTPUT_FORMAT=""
  _parse_command_line_arguments --output-format "zip"
  assertEquals "zip" "${__UAC_OUTPUT_FORMAT}"
}

test_parse_command_line_arguments_no_such_config_file_fail()
{
  assertFalse "_parse_command_line_arguments --config"
}

test_parse_command_line_arguments_config_file_success()
{
  __UAC_CONFIG_FILE=""
  _parse_command_line_arguments --config "${__TEST_TEMP_DIR}/test.conf"
  assertEquals "${__TEST_TEMP_DIR}/test.conf" "${__UAC_CONFIG_FILE}"
}

test_parse_command_line_arguments_no_such_mount_point_fail()
{
  assertFalse "_parse_command_line_arguments --mount-point"
}

test_parse_command_line_arguments_mount_point_success()
{
  __UAC_MOUNT_POINT=""
  _parse_command_line_arguments --mount-point "${__TEST_TEMP_DIR}/mount_point"
  assertEquals "${__TEST_TEMP_DIR}/mount_point" "${__UAC_MOUNT_POINT}"
}

test_parse_command_line_arguments_no_such_operating_system_fail()
{
  assertFalse "_parse_command_line_arguments --operating-system"
}

test_parse_command_line_arguments_operating_system_success()
{
  __UAC_OPERATING_SYSTEM=""
  _parse_command_line_arguments --operating-system linux
  assertEquals "linux" "${__UAC_OPERATING_SYSTEM}"
}

test_parse_command_line_arguments_no_such_hostname_fail()
{
  assertFalse "_parse_command_line_arguments --hostname"
}

test_parse_command_line_arguments_hostname_success()
{
  __UAC_HOSTNAME=""
  _parse_command_line_arguments --hostname testhost
  assertEquals "testhost" "${__UAC_HOSTNAME}"
}

test_parse_command_line_arguments_no_such_temp_dir_fail()
{
  assertFalse "_parse_command_line_arguments --temp-dir"
}

test_parse_command_line_arguments_temp_dir_success()
{
  __UAC_TEMP_DIR=""
  _parse_command_line_arguments --temp-dir "${__TEST_TEMP_DIR}/temp_dir"
  assertEquals "${__TEST_TEMP_DIR}/temp_dir" "${__UAC_TEMP_DIR}"
}

test_parse_command_line_arguments_no_such_start_date_fail()
{
  assertFalse "_parse_command_line_arguments --date-range-start"
}

test_parse_command_line_arguments_start_date_success()
{
  __UAC_START_DATE=""
  _parse_command_line_arguments --start-date "2001-01-01"
  assertEquals "2001-01-01" "${__UAC_START_DATE}"
}

test_parse_command_line_arguments_no_such_end_date_fail()
{
  assertFalse "_parse_command_line_arguments --date-range-end"
}

test_parse_command_line_arguments_end_date_success()
{
  __UAC_END_DATE=""
  _parse_command_line_arguments --end-date "2001-01-02"
  assertEquals "2001-01-02" "${__UAC_END_DATE}"
}

test_parse_command_line_arguments_no_such_case_number_fail()
{
  assertFalse "_parse_command_line_arguments --case-number"
}

test_parse_command_line_arguments_case_number_success()
{
  __UAC_CASE_NUMBER=""
  _parse_command_line_arguments --case-number X17X
  assertEquals "X17X" "${__UAC_CASE_NUMBER}"
}

test_parse_command_line_arguments_no_such_description_fail()
{
  assertFalse "_parse_command_line_arguments --description"
}

test_parse_command_line_arguments_description_success()
{
  __UAC_EVIDENCE_DESCRIPTION=""
  _parse_command_line_arguments --description "evidence description"
  assertEquals "evidence description" "${__UAC_EVIDENCE_DESCRIPTION}"
}

test_parse_command_line_arguments_no_such_evidence_number_fail()
{
  assertFalse "_parse_command_line_arguments --evidence-number"
}

test_parse_command_line_arguments_evidence_number_success()
{
  __UAC_EVIDENCE_NUMBER=""
  _parse_command_line_arguments --evidence-number 10
  assertEquals "10" "${__UAC_EVIDENCE_NUMBER}"
}

test_parse_command_line_arguments_no_such_examiner_fail()
{
  assertFalse "_parse_command_line_arguments --examiner"
}

test_parse_command_line_arguments_examiner_success()
{
  __UAC_EXAMINER=""
  _parse_command_line_arguments --examiner "Hal 9000"
  assertEquals "Hal 9000" "${__UAC_EXAMINER}"
}

test_parse_command_line_arguments_no_such_notes_fail()
{
  assertFalse "_parse_command_line_arguments --notes"
}

test_parse_command_line_arguments_notes_success()
{
  __UAC_EVIDENCE_NOTES=""
  _parse_command_line_arguments --notes "Heuristically programmed ALgorithmic computer"
  assertEquals "Heuristically programmed ALgorithmic computer" "${__UAC_EVIDENCE_NOTES}"
}

test_parse_command_line_arguments_invalid_option_fail()
{
  assertFalse "_parse_command_line_arguments -invalid-option"
  assertFalse "_parse_command_line_arguments --invalid-option"
}

test_parse_command_line_arguments_destination_directory_success()
{
  __UAC_DESTINATION_DIR=""
  _parse_command_line_arguments "${__TEST_TEMP_DIR}/destination_dir"
  assertEquals "${__TEST_TEMP_DIR}/destination_dir" "${__UAC_DESTINATION_DIR}"
}