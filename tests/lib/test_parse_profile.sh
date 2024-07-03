#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/parse_profile.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_parse_profile"

  mkdir -p "${__TEST_TEMP_DIR}/profiles"

  cat <<EOF >"${__TEST_TEMP_DIR}/profiles/profile_success.yaml"
name: test
description: test profile
artifacts:
  - test01/test01.yaml
  - !test02.yaml
#  - test03/test03.yaml
  - test04.yaml # comments

  - !test05/"test05 with spaces.yaml"
  - test06.yaml

EOF

}

test_parse_profile_success()
{ 
  __test_actual=`_parse_profile "${__TEST_TEMP_DIR}/profiles/profile_success.yaml"`
  assertEquals "test01/test01.yaml,!test02.yaml,test04.yaml,!test05/\"test05 with spaces.yaml\",test06.yaml" "${__test_actual}"
}
