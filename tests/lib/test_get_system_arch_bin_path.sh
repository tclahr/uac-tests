#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_system_arch_bin_path.sh"
}

test_get_system_arch_bin_path_success()
{
  __test_actual=`_get_system_arch_bin_path "armv6"`
  assertEquals "arm" "${__test_actual}"

  __test_actual=`_get_system_arch_bin_path "i386"`
  assertEquals "i686" "${__test_actual}"

  __test_actual=`_get_system_arch_bin_path "s390x"`
  assertEquals "s390x" "${__test_actual}"

}

