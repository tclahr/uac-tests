#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2129,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/remove_non_regular_files.sh"

  _log_msg()
  {
    __lm_level="${1:-INF}"
    __lm_message="${2:-}"

    printf %b "YYYYMMDD hh:mm:ss Z ${__lm_level} ${__lm_message}\n" \
      >>"${__TEST_TEMP_DIR}/test.log" \
      2>/dev/null
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/remove_non_regular_files"

  mkdir -p "${__TEST_TEMP_DIR}/mount-point"

  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"

  __UAC_TOOL_XARGS_MAX_PROCS_PARAM=""

  mkdir -p "${__TEST_TEMP_DIR}/mount-point/etc/default"
  echo "issue" >"${__TEST_TEMP_DIR}/mount-point/etc/issue"
  echo "keyboard" >"${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard"
  mkdir -p "${__TEST_TEMP_DIR}/mount-point/empty"
  mkdir -p "${__TEST_TEMP_DIR}/mount-point/bin"
  echo "lsof" >"${__TEST_TEMP_DIR}/mount-point/bin/lsof"
  echo "netstat" >"${__TEST_TEMP_DIR}/mount-point/bin/netstat"
  mkdir -p "${__TEST_TEMP_DIR}/mount-point/sbin"
  mkdir -p "${__TEST_TEMP_DIR}/mount-point/usr/bin"
  ln -s "${__TEST_TEMP_DIR}/mount-point/bin/netstat" "${__TEST_TEMP_DIR}/mount-point/bin/ss"

}

setUp()
{
  __UAC_TOOL_FIND_TYPE_SUPPORT=true

  echo "${__TEST_TEMP_DIR}/mount-point/etc/issue" >"${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  echo "${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard" >>"${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  echo "${__TEST_TEMP_DIR}/mount-point/empty" >>"${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  echo "${__TEST_TEMP_DIR}/mount-point/sbin" >>"${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  echo "${__TEST_TEMP_DIR}/mount-point/bin/lsof" >>"${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  echo "${__TEST_TEMP_DIR}/mount-point/bin/netstat" >>"${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  echo "${__TEST_TEMP_DIR}/mount-point/bin/ss" >>"${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  echo "/dev/null" >>"${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  echo "${__TEST_TEMP_DIR}/mount-point/usr/bin" >>"${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
}

test_remove_non_regular_files_success()
{
  _remove_non_regular_files "${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  __test_actual=`cat "${__UAC_TEMP_DATA_DIR}/file_collector.tmp"`

  assertEquals "${__TEST_TEMP_DIR}/mount-point/bin/lsof
${__TEST_TEMP_DIR}/mount-point/bin/netstat
${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard
${__TEST_TEMP_DIR}/mount-point/etc/issue" "${__test_actual}"

}

test_remove_non_regular_files_no_find_type_support_success()
{
  __UAC_TOOL_FIND_TYPE_SUPPORT=false

  _remove_non_regular_files "${__UAC_TEMP_DATA_DIR}/file_collector.tmp"
  __test_actual=`cat "${__UAC_TEMP_DATA_DIR}/file_collector.tmp"`

  assertEquals "${__TEST_TEMP_DIR}/mount-point/bin/lsof
${__TEST_TEMP_DIR}/mount-point/bin/netstat
${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard
${__TEST_TEMP_DIR}/mount-point/etc/issue" "${__test_actual}"

}