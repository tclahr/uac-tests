#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/error_msg.sh"
}

test_error_msg_success()
{
  __test_actual=`_error_msg "error message test" 2>&1`
  assertEquals "uac: error message test" "${__test_actual}"
}

test_error_msg_empty_message_success()
{
  __test_actual=`_error_msg 2>&1`
  assertEquals "uac: unexpected error" "${__test_actual}"
}
