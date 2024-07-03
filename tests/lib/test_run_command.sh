#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/run_command.sh"

  _log_msg()
  {
    __lm_level="${1:-INF}"
    __lm_message="${2:-}"

    printf %b "YYYYMMDD hh:mm:ss Z ${__lm_level} ${__lm_message}\n" \
      >>"${__TEST_TEMP_DIR}/test.log" \
      2>/dev/null
  }
  
  __ps()
  {
    cat << EOF
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 07:54 ?        00:00:01 /sbin/init
root           2       0  0 07:54 ?        00:00:00 [kthreadd]
root           3       2  0 07:54 ?        00:00:00 [rcu_gp]
EOF
  }
  
  __unknown_command()
  {
    printf %b "unknown command error\nplease try again later\n" >&2
    return 1
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_run_command"
  
  mkdir -p "${__TEST_TEMP_DIR}"
  
  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"

}

test_run_command_command_success()
{
  __test_container=`_run_command "__ps"`
  assertContains "${__test_container}" "kthreadd"
}

test_run_command_command_ignore_stderr_success()
{
  assertFalse "_run_command \"__unknown_command\" false"
  __test_container=`cat "${__TEST_TEMP_DIR}/test.log"`
  assertNotContains "${__test_container}" "unknown command error"
}

test_run_command_command_unknown_command_success()
{
  assertFalse "_run_command \"__unknown_command\""
   __test_container=`cat "${__TEST_TEMP_DIR}/test.log"`
  assertContains "${__test_container}" "unknown command error"
}

test_run_command_command_log_msg_success()
{
  __test_container=`_run_command "__ps"`
  __test_container=`cat "${__TEST_TEMP_DIR}/test.log"`
  assertContains "${__test_container}" "YYYYMMDD hh:mm:ss Z CMD __ps"
  assertContains "${__test_container}" "YYYYMMDD hh:mm:ss Z CMD __unknown_command 2> unknown command error"
}

test_run_command_empty_command_fail()
{
  assertFalse "_run_command \"\""
}

test_run_command_empty_temp_data_dir_fail()
{
  __UAC_TEMP_DATA_DIR=""
  assertFalse "_run_command \"__ps\""
}