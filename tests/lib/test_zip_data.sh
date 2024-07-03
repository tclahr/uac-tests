#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/zip_data.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  _verbose_msg()
  {
    return 0
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_zip_data"

  mkdir -p "${__TEST_TEMP_DIR}/mount-point/etc/default"
  echo "issue" >"${__TEST_TEMP_DIR}/mount-point/etc/issue"
  echo "keyboard" >"${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard"

  echo "${__TEST_TEMP_DIR}/mount-point/etc/issue" >>"${__TEST_TEMP_DIR}/file_list.txt"
  echo "${__TEST_TEMP_DIR}/mount-point/etc/default/keyboard" >>"${__TEST_TEMP_DIR}/file_list.txt"

  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"
  __UAC_VERBOSE_CMD_PREFIX=" > "

}

test_zip_data_no_such_file_fail()
{
  if commandExists "zip"; then
    assertFalse "_zip_data \"${__TEST_TEMP_DIR}/no_such_file.txt\" \"${__TEST_TEMP_DIR}/no_such_file_fail.zip\""
  else
    skipTest "no such file or directory: 'zip'"
  fi
}

test_zip_data_success()
{
  if commandExists "zip"; then
    assertTrue "_zip_data \"${__TEST_TEMP_DIR}/file_list.txt\" \"${__TEST_TEMP_DIR}/success.zip\""
    assertFileExists "${__TEST_TEMP_DIR}/success.zip"
    assertTrue "_zip_data \"${__TEST_TEMP_DIR}/file_list.txt\" \"${__TEST_TEMP_DIR}/success_new_password.zip\" \"new_password\""
    assertFileExists "${__TEST_TEMP_DIR}/success_new_password.zip"
  else
    skipTest "no such file or directory: 'zip'"
  fi
}