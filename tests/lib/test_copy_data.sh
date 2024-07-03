#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2129,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/copy_data.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  _log_msg()
  {
    __lm_level="${1:-INF}"
    __lm_message="${2:-}"

    printf %b "YYYYMMDD hh:mm:ss Z ${__lm_level} ${__lm_message}\n" \
      >>"${__TEST_TEMP_DIR}/test.log" \
      2>/dev/null
  }

  _run_command()
  {
    __rc_command=`printf %b "${1}" | awk 'BEGIN {ORS="/n"} {print $0}' | sed -e 's|  *| |g' -e 's|/n$||'`
    _log_msg CMD "${__rc_command}"
    eval "${1:-}"
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_copy_data"
 
  mkdir -p "${__TEST_TEMP_DIR}/mount-point/etc/default"
  echo "issue" >"${__TEST_TEMP_DIR}/mount-point/etc/issue"
  echo "keyboard" >"${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard"
  mkdir -p "${__TEST_TEMP_DIR}/mount-point/bin"
  echo "lsof" >"${__TEST_TEMP_DIR}/mount-point/bin/lsof"
  echo "netstat" >"${__TEST_TEMP_DIR}/mount-point/bin/netstat"

  echo "${__TEST_TEMP_DIR}/mount-point/etc/issue" >>"${__TEST_TEMP_DIR}/file_list.txt"
  echo "${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard" >>"${__TEST_TEMP_DIR}/file_list.txt"
  echo "${__TEST_TEMP_DIR}/mount-point/bin/lsof" >>"${__TEST_TEMP_DIR}/file_list.txt"
  echo "${__TEST_TEMP_DIR}/mount-point/bin/netstat" >>"${__TEST_TEMP_DIR}/file_list.txt"

  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"
  __UAC_MOUNT_POINT="${__TEST_TEMP_DIR}/mount-point"

  mkdir -p "${__TEST_TEMP_DIR}/[root]"

}

test_copy_data_no_such_from_file_fail()
{
  assertFalse "_copy_data \"${__TEST_TEMP_DIR}/no_such_file.txt\" \"${__TEST_TEMP_DIR}/[root]\""
}

test_copy_data_success()
{
  _copy_data "${__TEST_TEMP_DIR}/file_list.txt" "${__TEST_TEMP_DIR}/[root]"
  assertFileExists "${__TEST_TEMP_DIR}/[root]/etc/default/keyboard"
  assertFileExists "${__TEST_TEMP_DIR}/[root]/bin/lsof"
}