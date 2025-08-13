#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  # shellcheck disable=SC2153
  . "${UAC_DIR}/lib/get_bin_path.sh"

  # shellcheck disable=SC2329
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

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_get_bin_path"

  mkdir -p "${__TEST_TEMP_DIR}/uac"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin/aix"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin/android"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin/esxi"
  mkdir -p "${__TEST_TEMP_DIR}/uac/bin/netscaler"
  
  __UAC_DIR="${__TEST_TEMP_DIR}/uac"

}

test_get_bin_path_success()
{
  __test_actual=`_get_bin_path "aix" "ppc64le"`
  assertEquals "${__TEST_TEMP_DIR}/uac/bin/aix/ppc64le:${__TEST_TEMP_DIR}/uac/bin/aix:${__TEST_TEMP_DIR}/uac/bin" "${__test_actual}"
  
  __test_actual=`_get_bin_path "openbsd" "amd64"`
  assertEquals "${__TEST_TEMP_DIR}/uac/bin" "${__test_actual}"
}

