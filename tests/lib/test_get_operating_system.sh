#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_operating_system.sh"
}

test_get_operating_system_aix_success()
{
  # stub
  uname()
  {
    printf %b "AIX"
  }

  __test_actual=`_get_operating_system`
  assertEquals "aix" "${__test_actual}"
}

test_get_operating_system_freebsd_success()
{
  # stub
  uname()
  {
    printf %b "FreeBSD"
  }

  __test_actual=`_get_operating_system`
  assertEquals "freebsd" "${__test_actual}"
}

test_get_operating_system_netscaler_success()
{
  # stub
  uname()
  {
    if [ "${1}" = "-s" ]; then
      printf %b "FreeBSD"
    else
      printf %b "8.4-NETSCALER-13.0"
    fi
  }

  __test_actual=`_get_operating_system`
  assertEquals "netscaler" "${__test_actual}"
}

test_get_operating_system_linux_success()
{
  # stub
  uname()
  {
    printf %b "Linux"
  }

  __test_actual=`_get_operating_system`
  assertEquals "linux" "${__test_actual}"
}

test_get_operating_system_macos_success()
{
  # stub
  uname()
  {
    printf %b "Darwin"
  }

  __test_actual=`_get_operating_system`
  assertEquals "macos" "${__test_actual}"
}

test_get_operating_system_netbsd_success()
{
  # stub
  uname()
  {
    printf %b "NetBSD"
  }

  __test_actual=`_get_operating_system`
  assertEquals "netbsd" "${__test_actual}"
}

test_get_operating_system_openbsd_success()
{
  # stub
  uname()
  {
    printf %b "OpenBSD"
  }

  __test_actual=`_get_operating_system`
  assertEquals "openbsd" "${__test_actual}"
}

test_get_operating_system_solaris_success()
{
  # stub
  uname()
  {
    printf %b "SunOS"
  }

  __test_actual=`_get_operating_system`
  assertEquals "solaris" "${__test_actual}"
}

test_get_operating_system_esxi_success()
{
  # stub
  uname()
  {
    printf %b "VMkernel"
  }

  __test_actual=`_get_operating_system`
  assertEquals "esxi" "${__test_actual}"
}

test_get_operating_system_unknown_operating_system_success()
{
  # stub
  uname()
  {
    printf %b "Unknown"
  }

  __test_actual=`_get_operating_system`
  assertEquals "Unknown" "${__test_actual}"
}
