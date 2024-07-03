#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_days_since_date_until_now.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  _get_epoch_date()
  {
    if [ -z "${1:-}" ]; then
      printf %b "1673319600" # 2023-01-10
    elif [ "${1}" = "2023-01-01" ]; then
      printf %b "1672542000" # 2023-01-01
    else
      printf %b "1675134000" # 2023-01-31
    fi
  }
}

test_get_days_since_date_until_now_success()
{
  __test_actual=`_get_days_since_date_until_now "2023-01-01"`
  assertEquals "9" "${__test_actual}"
}

test_get_days_since_date_until_now_empty_date_fail()
{
  assertFalse "_get_days_since_date_until_now"
}

test_get_days_since_date_until_now_date_greater_than_today_fail()
{
  assertFalse "_get_days_since_date_until_now 2023-01-31"
}