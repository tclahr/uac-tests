#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2153,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/tar_gz_data.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  _verbose_msg()
  {
    return 0
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_tar_gz_data"

  mkdir -p "${__TEST_TEMP_DIR}/mount-point/etc/default"
  mkdir -p "${__TEST_TEMP_DIR}/uac"
  echo "uac" >"${__TEST_TEMP_DIR}/uac/uac"
  echo "issue" >"${__TEST_TEMP_DIR}/mount-point/etc/issue"
  echo "keyboard" >"${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard"

  echo "${__TEST_TEMP_DIR}/mount-point/etc/issue" >>"${__TEST_TEMP_DIR}/file_list.txt"
  echo "${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard" >>"${__TEST_TEMP_DIR}/file_list.txt"

  __UAC_DIR="${__TEST_TEMP_DIR}/uac"
  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"
  __UAC_VERBOSE_CMD_PREFIX=" > "
  __UAC_TOOL_TAR_NO_FROM_FILE_SUPPORT=true

}

test_tar_gz_data_no_such_file_fail()
{
  if commandExists "tar"; then
    if commandExists "gzip"; then
      assertFalse "_tar_gz_data \"${__TEST_TEMP_DIR}/no_such_file.txt\" \"${__TEST_TEMP_DIR}/no_such_file_fail.tar\""
    else
      skipTest "no such file or directory: 'gzip'"
    fi
  else
    skipTest "no such file or directory: 'tar'"
  fi
}

test_tar_gz_data_success()
{
  __UAC_OPERATING_SYSTEM="${TEST_SYSTEM_OS:-}"

  if commandExists "tar"; then
    if commandExists "gzip"; then
      if [ -n "${__UAC_OPERATING_SYSTEM}" ]; then
        assertTrue "_tar_gz_data \"${__TEST_TEMP_DIR}/file_list.txt\" \"${__TEST_TEMP_DIR}/success.tar.gz\""
        assertFileExists "${__TEST_TEMP_DIR}/success.tar.gz"
      else
        skipTest "TEST_SYSTEM_OS not defined"
      fi
    else
      skipTest "no such file or directory: 'gzip'"
    fi
  else
    skipTest "no such file or directory: 'tar'"
  fi

}