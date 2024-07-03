#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/grep_o.sh"

   __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_grep_o"

  mkdir -p "${__TEST_TEMP_DIR}"

  cat <<EOF >"${__TEST_TEMP_DIR}/pattern_match_file.txt"
this is a test file
which contains random data
to be used during _grep_o testing.
EOF
}

test_grep_o_pattern_match_string_success()
{
  __test_string="MD5 (/bin/sh) = (42d3ba930e8612ae9ffa2586890c40b2) /bin/sh"
  __test_pattern="[0-9a-f]\{32\}"
  __test_actual=`printf %b "${__test_string}" | _grep_o "${__test_pattern}"`
  assertEquals "42d3ba930e8612ae9ffa2586890c40b2" "${__test_actual}"
}

test_grep_o_pattern_match_string_fail()
{
  __test_string="MD5 (/bin/sh) = (42d3ba930e8612ae9ffa2586890c40b2) /bin/sh"
  __test_pattern="[0-9]\{32\}"
  __test_actual=`printf %b "${__test_string}" | _grep_o "${__test_pattern}"`
  assertNotEquals "42d3ba930e8612ae9ffa2586890c40b2" "${__test_actual}"
}

test_grep_o_pattern_match_file_success()
{
  __test_pattern="random"
  __test_actual=`_grep_o "${__test_pattern}" <"${__TEST_TEMP_DIR}/pattern_match_file.txt"`
  assertEquals "random" "${__test_actual}"
}

