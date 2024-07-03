#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/sort_uniq_file.sh"

  _log_msg()
  {
    __lm_level="${1:-INF}"
    __lm_message="${2:-}"

    printf %b "YYYYMMDD hh:mm:ss Z ${__lm_level} ${__lm_message}\n" \
      >>"${__TEST_TEMP_DIR}/test.log" \
      2>/dev/null
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_sort_uniq_file"

  mkdir -p "${__TEST_TEMP_DIR}"

  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"

  cat <<EOF >"${__TEST_TEMP_DIR}/file.txt"
aaa
fff
ccc
eee
bbb
ddd


hhh
ggg

EOF

}

test_sort_uniq_file_success()
{
  _sort_uniq_file "${__TEST_TEMP_DIR}/file.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/file.txt"`
  assertEquals "aaa
bbb
ccc
ddd
eee
fff
ggg
hhh" "${__test_actual}"

}
