#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/is_root.sh"
}

test_is_root_id_success()
{
  # stub
  id()
  {
    printf %b "0"
  }

  assertTrue "_is_root"
}

test_is_root_id_fail()
{
  # stub
  id()
  {
    printf %b "1000"
  }

  assertFalse "_is_root"
}

test_is_root_defined_os_etc_passwd_success()
{
  # stub
  id()
  {
    return 1
  }

  if [ -f "/etc/passwd" ]; then
    # stub
    _get_current_user()
    {
      grep -E ":0:0:" /etc/passwd 2>/dev/null \
        | head -1 | awk 'BEGIN { FS=":"; } { print $1; }' 2>/dev/null
    }

    assertTrue "_is_root"
  else
    skipTest "no such file or directory: '/etc/passwd'"
  fi
}

test_is_root_defined_os_etc_passwd_fail()
{
  # stub
  id()
  {
    return 1
  }

  if [ -f "/etc/passwd" ]; then
    # stub
    _get_current_user()
    {
      grep -v -E ":0:0:" /etc/passwd 2>/dev/null \
        | head -1 | awk 'BEGIN { FS=":"; } { print $1; }' 2>/dev/null
    }

    assertFalse "_is_root"
  else
    skipTest "no such file or directory: '/etc/passwd'"
  fi
}