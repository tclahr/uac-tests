#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_profile_by_name.sh"

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_get_profile_by_name"

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

test_get_profile_empty_profile_name_success()
{
  __test_actual=`_get_profile_by_name "" "${__TEST_TEMP_DIR}/profiles"`
  assertNull "${__test_actual}"
}

test_get_profile_empty_profile_directory_success()
{
  __test_actual=`_get_profile_by_name "profile01" ""`
  assertNull "${__test_actual}"
}

test_get_profile_invalid_profile_name_success()
{
  __test_actual=`_get_profile_by_name "invalid" "${__TEST_TEMP_DIR}/profiles"`
  assertNull "${__test_actual}"
}

test_get_profile_substring_profile_name_fail()
{
  __test_actual=`_get_profile_by_name "profile" "${__TEST_TEMP_DIR}/profiles"`
  assertNull "${__test_actual}"
}

test_get_profile_valid_profile_name_success()
{
  __test_actual=`_get_profile_by_name "profile01" "${__TEST_TEMP_DIR}/profiles"`
  assertEquals "${__TEST_TEMP_DIR}/profiles/profile01.yaml" "${__test_actual}"

  __test_actual=`_get_profile_by_name "profile02" "${__TEST_TEMP_DIR}/profiles"`
  assertEquals "${__TEST_TEMP_DIR}/profiles/profile02.yaml" "${__test_actual}"
}
