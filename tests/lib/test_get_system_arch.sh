#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_system_arch.sh"
}

setUp()
{
  unset -f uname
  return 0
}

test_get_system_arch_all_os_success()
{
  # stub
  uname() { printf %b "x86_64"; }

  __test_actual=`_get_system_arch aix`
  assertEquals "x86_64" "${__test_actual}"
  __test_actual=`_get_system_arch esxi`
  assertEquals "x86_64" "${__test_actual}"
  __test_actual=`_get_system_arch freebsd`
  assertEquals "x86_64" "${__test_actual}"
  __test_actual=`_get_system_arch linux`
  assertEquals "x86_64" "${__test_actual}"
  __test_actual=`_get_system_arch macos`
  assertEquals "x86_64" "${__test_actual}"
  __test_actual=`_get_system_arch netbsd`
  assertEquals "x86_64" "${__test_actual}"
  __test_actual=`_get_system_arch netscaler`
  assertEquals "x86_64" "${__test_actual}"
  __test_actual=`_get_system_arch openbsd`
  assertEquals "x86_64" "${__test_actual}"
  __test_actual=`_get_system_arch solaris`
  assertEquals "x86_64" "${__test_actual}"
}

test_get_system_arch_unknown_os_fail()
{
  # stub
  uname() { printf %b "x86_64"; }

  __test_actual=`_get_system_arch non-existent-os`
  assertNull "${__test_actual}"
}

test_get_system_arch_defined_arch_success()
{
  if [ -n "${TEST_SYSTEM_ARCH:-}" ] && [ -n "${TEST_SYSTEM_OS:-}" ]; then
    __test_actual=`_get_system_arch "${TEST_SYSTEM_OS}"`
    assertEquals "${TEST_SYSTEM_ARCH}" "${__test_actual}"
  else
    skipTest "TEST_SYSTEM_ARCH and TEST_SYSTEM_OS not defined"
  fi
}