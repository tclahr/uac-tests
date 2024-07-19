#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2153

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_bin_path.sh"

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_get_bin_path"

  mkdir -p "${__TEST_TEMP_DIR}/uac"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin/aix"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin/android"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin/esxi"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin/netscaler"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx/android"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx/esxi_linux"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx/linux"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx/netscaler"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/zip"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/zip/freebsd_netscaler"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/zip/solaris"

  __UAC_DIR="${__TEST_TEMP_DIR}/uac"

}

test_get_bin_path_success()
{
  # TO DO: test zip tool
  __test_actual=`_get_bin_path "android" "armv6"`
  assertEquals "${__TEST_TEMP_DIR}/uac/tools/statx/android/arm:${__TEST_TEMP_DIR}/uac/bin/android/arm:${__TEST_TEMP_DIR}/uac/bin/android:${__TEST_TEMP_DIR}/uac/bin" "${__test_actual}"

  __test_actual=`_get_bin_path "esxi" "i386"`
  assertEquals "${__TEST_TEMP_DIR}/uac/tools/statx/esxi_linux/i686:${__TEST_TEMP_DIR}/uac/bin/esxi/i686:${__TEST_TEMP_DIR}/uac/bin/esxi:${__TEST_TEMP_DIR}/uac/bin" "${__test_actual}"

  __test_actual=`_get_bin_path "aix" "ppc64le"`
  assertEquals "${__TEST_TEMP_DIR}/uac/bin/aix/ppc64le:${__TEST_TEMP_DIR}/uac/bin/aix:${__TEST_TEMP_DIR}/uac/bin" "${__test_actual}"
  
  __test_actual=`_get_bin_path "openbsd" "amd64"`
  assertEquals "${__TEST_TEMP_DIR}/uac/bin" "${__test_actual}"
}

