#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_current_user.sh"
}

setUp()
{
  LOGNAME=""
  USER=""

  id()
  {
    printf %b "uid=1000(duncan) gid=1000(duncan) groups=1000(duncan),998(wheel)"
  }
  return 0
}

test_get_current_user_LOGNAME_var_success()
{
  # stub
  LOGNAME="duncan"

  __test_actual=`_get_current_user`
  assertEquals "duncan" "${__test_actual}"
}

test_get_current_user_USER_var_success()
{
  # stub
  USER="duncan"

  __test_actual=`_get_current_user`
  assertEquals "duncan" "${__test_actual}"
}

test_get_current_user_id_success()
{
  __test_actual=`_get_current_user`
  assertEquals "duncan" "${__test_actual}"
}
