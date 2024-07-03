#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/init_temp_data_dir.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_init_temp_data_dir"
  
}

setUp()
{
  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}/uac-data.tmp"
  __UAC_LOG_FILE="uac.log"
}

test_init_temp_data_dir_cannot_remove_old_data_fail()
{
  # stub
  rm()
  {
    return 1
  }
  
  mkdir -p "${__TEST_TEMP_DIR}/uac-data.tmp"
  assertFalse "_init_temp_data_dir"
  unset -f rm
}

test_init_temp_data_dir_cannot_create_temp_data_dir_fail()
{
  __UAC_TEMP_DATA_DIR="/dev/null"
  assertFalse "_init_temp_data_dir"
}

test_init_temp_data_dir_success()
{
  assertTrue "_init_temp_data_dir"
}