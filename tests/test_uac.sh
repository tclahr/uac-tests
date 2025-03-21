#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC2006,SC2317

oneTimeSetUp()
{
  
  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_uac"
  mkdir -p "${__TEST_TEMP_DIR}/mount-point/dev/shm"
  echo "file01" >"${__TEST_TEMP_DIR}/mount-point/dev/shm/file01"
  echo "file02" >"${__TEST_TEMP_DIR}/mount-point/dev/shm/file02"
  
  cat <<EOF >"${UAC_DIR}/profiles/test.yaml"
name: test
description: test profile
artifacts:
  - live_response/storage/df.yaml
EOF

  cat <<EOF >"${__TEST_TEMP_DIR}/external_artifact.yaml"
version: 1.0
output_directory: external_artifact
artifacts:
  -
    description: Report a snapshot of the current processes.
    supported_os: [all]
    collector: command
    command: df
    output_file: df.txt
EOF

  cat <<EOF >"${__TEST_TEMP_DIR}/external_profile.yaml"
name: external_profile
description: test external profile
artifacts:
  - live_response/storage/df.yaml
EOF

  cat <<EOF >"${__TEST_TEMP_DIR}/external_profile_with_external_artifact.yaml"
name: external_profile
description: test external profile
artifacts:
  - live_response/storage/df.yaml
  - ${__TEST_TEMP_DIR}/external_artifact.yaml
EOF

}

test_uac_test_profile_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -u \"${__TEST_TEMP_DIR}\""
}

test_uac_test_profile_and_artifacts_success()
{
  sleep 1
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -a ./artifacts/files/system/etc.yaml -v -u \"${__TEST_TEMP_DIR}\""
}

test_uac_output_base_name_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -v -u --output-base-name \"test_uac_output_base_name_success\" \"${__TEST_TEMP_DIR}\""
  if commandExists "gzip"; then
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_base_name_success.tar.gz"
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_base_name_success.log"
  else
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_base_name_success.tar"
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_base_name_success.log"
  fi
}

test_uac_empty_output_base_name_fail()
{
  assertFalse "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -v -u --output-base-name \"\" \"${__TEST_TEMP_DIR}\""
}

test_uac_debug_mode_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -v -u --debug --output-base-name \"test_uac_debug_mode_success\" \"${__TEST_TEMP_DIR}\""
  assertDirectoryExists "${__TEST_TEMP_DIR}/uac-data.tmp"
  assertFileExists "${__TEST_TEMP_DIR}/uac-data.tmp/collected/uac.log"
}

test_uac_verbose_mode_success()
{
  __test_actual=`cd "${UAC_DIR}" && /bin/sh ./uac -p test -u --verbose --output-base-name "test_uac_verbose_mode_success" "${__TEST_TEMP_DIR}"`
  assertContains "${__test_actual}" " > df"
}

test_uac_external_profile_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p \"${__TEST_TEMP_DIR}/external_profile.yaml\" -v -u --output-base-name \"test_uac_external_profile_success\" \"${__TEST_TEMP_DIR}\""
}

test_uac_invalid_external_profile_fail()
{
  assertFalse "cd \"${UAC_DIR}\" && /bin/sh ./uac -p \"${__TEST_TEMP_DIR}/invalid.yaml\" -v -u --output-base-name \"test_uac_invalid_external_profile_fail\" \"${__TEST_TEMP_DIR}\""
}

test_uac_external_artifact_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -a \"${__TEST_TEMP_DIR}/external_artifact.yaml\" -v -u --output-base-name \"test_uac_external_artifact_success\" \"${__TEST_TEMP_DIR}\""
}

test_uac_invalid_external_artifact_success()
{
  assertFalse "cd \"${UAC_DIR}\" && /bin/sh ./uac -a \"${__TEST_TEMP_DIR}/invalid.yaml\" -v -u --output-base-name \"test_uac_invalid_external_artifact_success\" \"${__TEST_TEMP_DIR}\""
}

test_uac_external_profile_with_external_artifact_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p \"${__TEST_TEMP_DIR}/external_profile_with_external_artifact.yaml\" -v -u --output-base-name \"test_uac_external_profile_with_external_artifact_success\" \"${__TEST_TEMP_DIR}\""

  if commandExists "gzip"; then
    gzip -d "${__TEST_TEMP_DIR}/test_uac_external_profile_with_external_artifact_success.tar.gz"
    __test_container=`tar -tf "${__TEST_TEMP_DIR}/test_uac_external_profile_with_external_artifact_success.tar"`
    assertContains "${__test_container}" "uac.log"
    assertContains "${__test_container}" "external_artifact/df.txt"
    assertContains "${__test_container}" "live_response/storage/df.txt"
  else
    skipTest "no such file or directory: 'gzip'"
  fi
  
}

test_uac_output_format_none_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -v -u --output-base-name \"test_uac_output_format_none_success\" --output-format none \"${__TEST_TEMP_DIR}\""
  assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_format_none_success/uac.log"
  assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_format_none_success.log"
}

test_uac_output_format_tar_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -v -u --output-base-name \"test_uac_output_format_tar_success\" --output-format tar \"${__TEST_TEMP_DIR}\""
  if commandExists "gzip"; then
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_format_tar_success.tar.gz"
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_format_tar_success.log"
    gzip -d "${__TEST_TEMP_DIR}/test_uac_output_format_tar_success.tar.gz"
  else
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_format_tar_success.tar"
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_format_tar_success.log"
  fi
  __test_container=`tar -tf "${__TEST_TEMP_DIR}/test_uac_output_format_tar_success.tar"`
  assertContains "${__test_container}" "uac.log"
  assertContains "${__test_container}" "live_response/storage/df.txt"
}

test_uac_output_format_zip_success()
{
  if cd "${UAC_DIR}" && /bin/sh ./uac -p test -v -u --output-base-name "test_uac_output_format_zip_success" --output-format zip "${__TEST_TEMP_DIR}"; then
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_format_zip_success.zip"
    assertFileExists "${__TEST_TEMP_DIR}/test_uac_output_format_zip_success.log"
    if commandExists "unzip"; then
      __test_actual=`unzip -l "${__TEST_TEMP_DIR}/test_uac_output_format_zip_success.zip"`
      assertContains "${__test_container}" "uac.log"
      assertContains "${__test_container}" "live_response/storage/df.txt"
    fi
  else
    skipTest "no such file or directory: 'zip'"
  fi
}

test_uac_invalid_output_format_fail()
{
  assertFalse "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -v -u --output-base-name \"test_uac_invalid_output_format_fail\" --output-format invalid \"${__TEST_TEMP_DIR}\""
}

test_uac_hash_collected_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -a ./artifacts/files/system/dev_shm.yaml -m \"${__TEST_TEMP_DIR}/mount-point\" -v -u --output-base-name \"test_uac_hash_collected_success\" --hash-collected \"${__TEST_TEMP_DIR}\""
  if commandExists "gzip"; then
    gzip -d "${__TEST_TEMP_DIR}/test_uac_hash_collected_success.tar.gz"
    __test_container=`tar -tf "${__TEST_TEMP_DIR}/test_uac_hash_collected_success.tar"`
    assertContains "${__test_container}" "uac.log"
    assertContains "${__test_container}" "[root]/dev/shm/file01"
    assertContains "${__test_container}" "[root]/dev/shm/file02"
    assertContains "${__test_container}" "hash_list.md5"
  else
    skipTest "no such file or directory: 'gzip'"
  fi
  
}

test_uac_truncated_output_file_output_format_none_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -v -u --output-base-name \"very_long_directory_name_with_many_characters_that_exceeds_the_standard_limit_of_filesystem_paths_another_very_long_directory_name_with_even_more_characters_that_pushes_the_limit_further_super_long_filename_that_keeps_going_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_none\" --output-format none \"${__TEST_TEMP_DIR}\""
  assertDirectoryExists "${__TEST_TEMP_DIR}/(trunc)oing_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_none"
  assertFileExists "${__TEST_TEMP_DIR}/(trunc)oing_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_none.log"
}

test_uac_truncated_output_file_output_format_tar_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -p test -v -u --output-base-name \"very_long_directory_name_with_many_characters_that_exceeds_the_standard_limit_of_filesystem_paths_another_very_long_directory_name_with_even_more_characters_that_pushes_the_limit_further_super_long_filename_that_keeps_going_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_tar\" --output-format tar \"${__TEST_TEMP_DIR}\""
  if commandExists "gzip"; then
    assertFileExists "${__TEST_TEMP_DIR}/(trunc)going_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_tar.tar.gz"
    assertFileExists "${__TEST_TEMP_DIR}/(trunc)going_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_tar.log"
    gzip -d "${__TEST_TEMP_DIR}/(trunc)going_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_tar.tar.gz"
  else
    assertFileExists "${__TEST_TEMP_DIR}/(trunc)going_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_tar.tar"
    assertFileExists "${__TEST_TEMP_DIR}/(trunc)going_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_tar.log"
  fi
  __test_container=`tar -tf "${__TEST_TEMP_DIR}/(trunc)going_and_going_until_it_reaches_and_exceeds_the_255_character_limit_and_some_more_characters_output_format_tar.tar"`
  assertContains "${__test_container}" "uac.log"
  assertContains "${__test_container}" "live_response/storage/df.txt"
}

test_uac_start_and_end_date_success()
{
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -a ./artifacts/files/system/etc.yaml -m \"${__TEST_TEMP_DIR}/mount-point\" -v -u --start-date 1999-01-01 --output-base-name \"test_uac_start_date_success\" \"${__TEST_TEMP_DIR}\""
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -a ./artifacts/files/system/etc.yaml -m \"${__TEST_TEMP_DIR}/mount-point\" -v -u --end-date 1999-01-31 --output-base-name \"test_uac_end_date_success\" \"${__TEST_TEMP_DIR}\""
  assertTrue "cd \"${UAC_DIR}\" && /bin/sh ./uac -a ./artifacts/files/system/etc.yaml -m \"${__TEST_TEMP_DIR}/mount-point\" -v -u --start-date 1999-01-01 --end-date 1999-01-31 --output-base-name \"test_uac_start_and_end_date_success\" \"${__TEST_TEMP_DIR}\""
}
