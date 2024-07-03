#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_epoch_date.sh"
}

setUp()
{
  unset -f date
  unset -f perl
  return 0
}

test_get_epoch_date_current_date_perl_success()
{
  # stub
  perl()
  {
    printf %b "1445470140"
  }

  __test_actual=`_get_epoch_date`
  assertEquals "1445470140" "${__test_actual}"
}

test_get_epoch_date_current_date_date_success()
{
  # stub
  perl() { return 1; }
  date()
  {
    printf %b "1445470141"
  }

  __test_actual=`_get_epoch_date`
  assertEquals "1445470141" "${__test_actual}"
}

test_get_epoch_date_given_date_date_d_success()
{
  # stub
  date()
  {
    case "${1}" in
      "-d")
        printf %b "1445470142"
        ;;
      *)
        return 1
        ;;
    esac
  }

  __test_actual=`_get_epoch_date "2015-10-21"`
  assertEquals "1445470142" "${__test_actual}"
}

test_get_epoch_date_given_date_date_j_success()
{
  # stub
  date()
  {
    case "${1}" in
      "-j")
        printf %b "1445470143"
        ;;
      *)
        return 1
        ;;
    esac
  }

  __test_actual=`_get_epoch_date "2015-10-21"`
  assertEquals "1445470143" "${__test_actual}"
}

test_get_epoch_date_given_date_perl_success()
{
  # stub
  date() { return 1; }
  date_to_epoch_pl()
  {
    printf %b "1445470144"
  }

  __test_actual=`_get_epoch_date "2015-10-21"`
  assertEquals "1445470144" "${__test_actual}"
}

test_get_epoch_date_defined_os_invalid_date_fail()
{
  if [ -n "${TEST_SYSTEM_OS:-}" ]; then
    assertFalse "_get_epoch_date \"2015-10-XX\""
  else
    skipTest "TEST_SYSTEM_OS not defined"
  fi
}

test_get_epoch_date_defined_os_success()
{
  if [ -n "${TEST_SYSTEM_OS:-}" ]; then
    __test_container=`_get_epoch_date`
    assertContains true "${__test_container}" "^[0-9]{9,}$"
  else
    skipTest "TEST_SYSTEM_OS not defined"
  fi
}