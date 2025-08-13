#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  PATH="${UAC_DIR}/bin:${PATH}"
}

test_timeout_insuficient_arguments_fail()
{
  assertFalse "timeout"
}

test_timeout_invalid_duration_fail()
{
  assertFalse "timeout invalid_duration"
}

test_timeout_command_not_found_fail()
{
  assertFalse "timeout 10 invalid_command"
}

test_timeout_invalid_arguments_fail()
{
  assertFalse "timeout -s 2 sleep 10"
  assertFalse "timeout -s SIGINVALID 2 sleep 10"
  assertFalse "timeout --signal=SIGINVALID 2 sleep 10"
  assertFalse "timeout --signal= 2 sleep 10"
  assertFalse "timeout -k 2 sleep 10"
  assertFalse "timeout --kill-after=INVALID 2 sleep 10"
  assertFalse "timeout --kill-after= 2 sleep 10"
  assertFalse "timeout -invalid_argument KILL 10 sleep 30"
}

test_timeout_no_timeout_command_success()
{
  assertTrue "timeout 10 sleep 1"
  assertTrue "timeout -s KILL 10 sleep 1"
  assertTrue "timeout -k 2 10 sleep 1"
}

test_timeout_command_timeout_success()
{
  assertFalse "timeout 1 sleep 10"
  assertFalse "timeout -s KILL 1 sleep 10"
  assertFalse "timeout -k 2 1 sleep 10"
}