#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/list_artifacts.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_list_artifacts"

  mkdir -p "${__TEST_TEMP_DIR}/artifacts/files"
  mkdir -p "${__TEST_TEMP_DIR}/artifacts/live_response/process"

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/files/artifact01.yaml"
version: 1.0
artifacts:
  -
    description: test01
    supported_os: [all]
    collector: hash
    path: /etc
    output_file: test.txt
EOF

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/live_response/process/artifact02.yaml"
version: 1.0
artifacts:
  -
    description: test02
    supported_os: [all]
    collector: command
    command: ls -la /
    output_file: test.txt
EOF

}

test_list_artifacts_no_such_directory_fail()
{
  assertFalse "_list_artifacts \"${__TEST_TEMP_DIR}/artifacts/invalid_list_artifacts_fail\""
}

test_list_artifacts_list_artifacts_success()
{
  assertTrue "_list_artifacts \"${__TEST_TEMP_DIR}/artifacts\""
}

test_list_artifacts_list_artifacts_output_success()
{
  __test_container=`_list_artifacts "${__TEST_TEMP_DIR}/artifacts"`
  assertContains "${__test_container}" "files/artifact01.yaml"
  assertContains "${__test_container}" "live_response/process/artifact02.yaml"
}
