#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/list_user_defined_variables.sh"

  # shellcheck disable=SC2329
  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_list_user_defined_variables"

  mkdir -p "${__TEST_TEMP_DIR}/artifacts/live_response/process"

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/artifact01.yaml"
version: 1.0
artifacts:
  -
    description: test01
    supported_os: [all]
    collector: hash
    path: /etc /%var01=value01%
    output_file: test.txt
EOF

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/artifact02.yaml"
version: 1.0
artifacts:
  -
    description: test01
    supported_os: [all]
    collector: command
    path: echo %os%
    output_file: test.txt
EOF

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/live_response/process/artifact03.yaml"
version: 1.0
artifacts:
  -
    description: test02
    supported_os: [all]
    collector: command
    command: ls -la /
    output_file: test.txt
EOF

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/live_response/process/artifact04.yaml"
version: 1.0
artifacts:
  -
    description: test02
    supported_os: [all]
    collector: command
    command: ls -la %var02%
    output_file: test.txt
EOF

}

test_list_user_defined_variables_invalid_artifacts_directory_fail()
{
  assertFalse "_list_user_defined_variables \"${__TEST_TEMP_DIR}/invalid_artifacts_directory\""
}

test_list_user_defined_variables_success()
{
  assertTrue "_list_user_defined_variables \"${__TEST_TEMP_DIR}\"/artifacts"
}

test_list_user_defined_variables_output_success()
{
  __test_container=`_list_user_defined_variables "${__TEST_TEMP_DIR}/artifacts"`
  assertContains "${__test_container}" "path: /etc /%var01=value01%"
  assertContains "${__test_container}" "command: ls -la %var02%"
  assertNotContains "${__test_container}" "path: echo %os%"
}
