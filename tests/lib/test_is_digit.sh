#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/is_digit.sh"
}

test_is_digit_number_success()
{
  assertTrue "_is_digit 42"
}

test_is_digit_zero_success()
{
  assertTrue "_is_digit 0"
}

test_is_digit_negative_number_success()
{
  assertTrue "_is_digit -42"
}

test_is_digit_string_fail()
{
  assertFalse "_is_digit uac"
}

test_is_digit_string_and_number_fail()
{
  assertFalse "_is_digit 123uac"
}

test_is_digit_float_fail()
{
  assertFalse "_is_digit 1.0"
}

test_is_digit_empty_fail()
{
  assertFalse "_is_digit"
}