#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/output_exists.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }
 
  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_output_exists"

  mkdir -p "${__TEST_TEMP_DIR}/output_directory"
  
  touch "${__TEST_TEMP_DIR}/tar_gz_output_file.tar.gz"
  touch "${__TEST_TEMP_DIR}/tar_output_file.tar"
  touch "${__TEST_TEMP_DIR}/zip_output_file.zip"

}

test_output_exists_directory_success()
{
  assertFalse "_output_exists \"${__TEST_TEMP_DIR}/nonexistent\""
  assertTrue "_output_exists \"${__TEST_TEMP_DIR}/output_directory\""
}

test_output_exists_tar_gz_success()
{
  assertFalse "_output_exists \"${__TEST_TEMP_DIR}/nonexistent\""
  assertTrue "_output_exists \"${__TEST_TEMP_DIR}/tar_gz_output_file.tar.gz\""
}
