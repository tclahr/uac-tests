#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2153,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_tools_path.sh"

  _get_system_arch_bin_path()
  {
    __gy_arch="${1:-x86_64}"

    case "${__gy_arch}" in
      armv[34567]*)
        echo "arm"
        ;;
      aarch64*|armv[89]*)
        echo "arm64"
        ;;
      athlon*|"i386"|"i486"|"i586"|"i686"|pentium*)
        echo "i686"
        ;;
      "mips"|"mipsel")
        echo "mips"
        ;;
      mips64*)
        echo "mips64"
        ;;
      "ppc")
        echo "ppc"
        ;;
      "ppcle")
        echo "ppcle"
        ;;
      "ppc64")
        echo "ppc64"
        ;;
      "ppc64le")
        echo "ppc64le"
        ;;
      s390*)
        echo "s390x"
        ;;
      "sparc")
        echo "sparc"
        ;;
      "sparc64")
        echo "sparc64"
        ;;
      *)
        echo "x86_64"
        ;;
    esac
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_get_tools_path"

  mkdir -p "${__TEST_TEMP_DIR}/uac"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx/android/arm"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx/esxi_linux/i686"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx/linux"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/statx/netscaler"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/zip"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/zip/freebsd_netscaler"
  mkdir -p "${__TEST_TEMP_DIR}/uac/tools/zip/solaris"

  __UAC_DIR="${__TEST_TEMP_DIR}/uac"

}

test_get_tools_path_success()
{
  # TO DO: test zip tool
  __test_actual=`_get_tools_path "android" "armv6"`
  assertEquals "${__TEST_TEMP_DIR}/uac/tools/statx/android/arm" "${__test_actual}"

  __test_actual=`_get_tools_path "esxi" "i386"`
  assertEquals "${__TEST_TEMP_DIR}/uac/tools/statx/esxi_linux/i686" "${__test_actual}"

}

