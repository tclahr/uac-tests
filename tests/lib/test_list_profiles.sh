#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/list_profiles.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_list_profiles"

  mkdir -p "${__TEST_TEMP_DIR}/profiles"

  cat <<EOF >"${__TEST_TEMP_DIR}/profiles/profile01.yaml"
name: profile01
description: profile01 description
artifacts:
  - artifacts/live_response/ps.yaml
EOF

  cat <<EOF >"${__TEST_TEMP_DIR}/profiles/profile02.yaml"
name: profile02
description: profile02 description
artifacts:
  - artifacts/live_response/ps.yaml
EOF

}

test_list_profiles_invalid_profiles_directory_fail()
{
  assertFalse "_list_profiles \"${__TEST_TEMP_DIR}/invalid_profiles_directory\""
}

test_list_profiles_list_profiles_success()
{
  assertTrue "_list_profiles \"${__TEST_TEMP_DIR}\"/profiles"
}

test_list_profiles_list_profiles_output_success()
{
  __test_container=`_list_profiles "${__TEST_TEMP_DIR}/profiles"`
  assertContains "${__test_container}" "profile01 : profile01 description"
  assertContains "${__test_container}" "profile02 : profile02 description"
}
