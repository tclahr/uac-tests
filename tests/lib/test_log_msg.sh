#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/log_msg.sh"

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_log_msg"

  mkdir -p "${__TEST_TEMP_DIR}"

  __UAC_LOG_FILE="uac.log"
  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"

}

setUp()
{
  __UAC_DEBUG_MODE=false
  touch "${__UAC_TEMP_DATA_DIR}/${__UAC_LOG_FILE}"
}

test_log_msg_err_no_such_file_fail()
{
  rm -f "${__UAC_TEMP_DATA_DIR}/${__UAC_LOG_FILE}"
  assertFalse "_log_msg ERR \"test_log_msg_err_no_such_file_fail\""
}

test_log_msg_dbg_level_success()
{
  _log_msg DBG "test_log_msg_dbg_level_success"
  __test_container=`cat "${__UAC_TEMP_DATA_DIR}/${__UAC_LOG_FILE}"`
  assertNotContains true "${__test_container}" "^[1|2][0-9]{3,3}-[0-9]{2,2}-[0-9]{2,2} [0-9]{2,2}:[0-9]{2,2}:[0-9]{2,2} .* DBG test_log_msg_dbg_level_success"

  __UAC_DEBUG_MODE=true

  _log_msg DBG "test_log_msg_dbg_level_success"
  __test_container=`cat "${__UAC_TEMP_DATA_DIR}/${__UAC_LOG_FILE}"`
  assertContains true "${__test_container}" "^[1|2][0-9]{3,3}-[0-9]{2,2}-[0-9]{2,2} [0-9]{2,2}:[0-9]{2,2}:[0-9]{2,2} .* DBG test_log_msg_dbg_level_success"
}

test_log_msg_inf_level_success()
{
  _log_msg INF "test_log_msg_inf_level_success"
  __test_container=`cat "${__UAC_TEMP_DATA_DIR}/${__UAC_LOG_FILE}"`
  assertContains true "${__test_container}" "^[1|2][0-9]{3,3}-[0-9]{2,2}-[0-9]{2,2} [0-9]{2,2}:[0-9]{2,2}:[0-9]{2,2} .* INF test_log_msg_inf_level_success"
}

test_log_msg_err_level_success()
{
  _log_msg ERR "test_log_msg_err_level_success"
  __test_container=`cat "${__UAC_TEMP_DATA_DIR}/${__UAC_LOG_FILE}"`
  assertContains true "${__test_container}" "^[1|2][0-9]{3,3}-[0-9]{2,2}-[0-9]{2,2} [0-9]{2,2}:[0-9]{2,2}:[0-9]{2,2} .* ERR test_log_msg_err_level_success"
}

test_log_msg_cmd_level_success()
{
  _log_msg CMD "test_log_msg_cmd_level_success"
  __test_container=`cat "${__UAC_TEMP_DATA_DIR}/${__UAC_LOG_FILE}"`
  assertContains true "${__test_container}" "^[1|2][0-9]{3,3}-[0-9]{2,2}-[0-9]{2,2} [0-9]{2,2}:[0-9]{2,2}:[0-9]{2,2} .* CMD test_log_msg_cmd_level_success"
}
