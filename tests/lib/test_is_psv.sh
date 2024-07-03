#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/is_psv.sh"
}

test_is_psv_success()
{
  assertTrue "_is_psv \"a|b\""
}

test_is_psv_fail()
{
  assertFalse "_is_psv \"a\""
}

test_is_psv_empty_string_fail()
{
  assertFalse "_is_psv \"\""
}
