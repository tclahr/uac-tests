#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317,SC2153

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/find_based_collector.sh"

  _build_find_command()
  {
    __bfc_path="${1:-}"
    shift
    __bfc_path_pattern="${1:-}"
    shift
    __bfc_name_pattern="${1:-}"
    shift
    __bfc_exclude_path_pattern="${1:-}"
    shift
    __bfc_exclude_name_pattern="${1:-}"
    shift
    __bfc_max_depth="${1:-}"
    shift
    __bfc_file_type="${1:-}"
    shift
    __bfc_min_file_size="${1:-}"
    shift
    __bfc_max_file_size="${1:-}"
    shift
    __bfc_permissions="${1:-}"
    shift
    __bfc_print0="${1:-false}"
    shift
    __bfc_start_date_days="${1:-0}"
    shift
    __bfc_end_date_days="${1:-0}"

    printf %s "_build_find_command \"${__bfc_path}\" \"${__bfc_path_pattern}\" \"${__bfc_name_pattern}\" \"${__bfc_exclude_path_pattern}\" \"${__bfc_exclude_name_pattern}\" \"${__bfc_max_depth}\" \"${__bfc_file_type}\" \"${__bfc_min_file_size}\" \"${__bfc_max_file_size}\" \"${__bfc_permissions}\" \"${__bfc_print0}\" \"${__bfc_start_date_days}\" \"${__bfc_end_date_days}\""
    _log_msg CMD "_build_find_command \"${__bfc_path}\" \"${__bfc_path_pattern}\" \"${__bfc_name_pattern}\" \"${__bfc_exclude_path_pattern}\" \"${__bfc_exclude_name_pattern}\" \"${__bfc_max_depth}\" \"${__bfc_file_type}\" \"${__bfc_min_file_size}\" \"${__bfc_max_file_size}\" \"${__bfc_permissions}\" \"${__bfc_print0}\" \"${__bfc_start_date_days}\" \"${__bfc_end_date_days}\""
  }

  _get_mount_point_by_file_system()
  {
    printf %s "/apfs|/mnt/ntfs"
  }

  _log_msg()
  {
    __lm_level="${1:-INF}"
    __lm_message="${2:-}"

    printf "YYYYMMDD hh:mm:ss Z %s %s\n" "${__lm_level}" "${__lm_message}" \
      >>"${__TEST_TEMP_DIR}/test.log" \
      2>/dev/null
  }

  _run_command()
  {
    printf %s "${1}"
    _log_msg CMD "${1}"
  }

  _sanitize_output_directory()
  {
    printf %s "${1:-}"
  }

  _sanitize_output_file()
  {
    printf %s "${1:-}"
  }

  _sanitize_path()
  {
    printf %s "${1:-}"
  }

  _verbose_msg()
  {
    return 0
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_find_based_collector"

  mkdir -p "${__TEST_TEMP_DIR}/mount-point"
  mkdir -p "${__TEST_TEMP_DIR}/uac"
  mkdir -p "${__TEST_TEMP_DIR}/collected/destination_directory"
  touch "${__TEST_TEMP_DIR}/uac/file_list.txt"
  touch "${__TEST_TEMP_DIR}/collected/file_list.txt"
  touch "${__TEST_TEMP_DIR}/collected/destination_directory/file_list.txt"

  __UAC_DIR="${__TEST_TEMP_DIR}/uac"
  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"
  
}

setUp()
{
  __UAC_MOUNT_POINT="${__TEST_TEMP_DIR}/mount-point"
  __UAC_OPERATING_SYSTEM="linux"
  __UAC_CONF_HASH_ALGORITHM="md5|sha1|sha256"
  __UAC_CONF_EXCLUDE_PATH_PATTERN=""
  __UAC_CONF_EXCLUDE_FILE_SYSTEM=""
  __UAC_CONF_EXCLUDE_NAME_PATTERN=""
  __UAC_START_DATE_DAYS=""
  __UAC_END_DATE_DAYS=""
  __UAC_EXCLUDE_MOUNT_POINTS=""

  __UAC_TOOL_FIND_PRINT0_SUPPORT=true
  __UAC_TOOL_XARGS_NULL_DELIMITER_SUPPORT=true

  __UAC_TOOL_MD5_BIN="md5sum"
  __UAC_TOOL_SHA1_BIN="sha1sum"
  __UAC_TOOL_SHA256_BIN="sha256sum"

  __UAC_TOOL_STAT_BIN="stat"
  __UAC_TOOL_STAT_PARAMS="-c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\""

  __UAC_VERBOSE_CMD_PREFIX=" > "
}

test_find_based_collector_empty_collector_fail()
{
  assertFalse "_find_based_collector \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\""
}

test_find_based_collector_empty_path_fail()
{
  assertFalse "_find_based_collector \
    \"find\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\""
}

test_find_based_collector_empty_output_directory_fail()
{
  assertFalse "_find_based_collector \
    \"find\" \
    \"${__TEST_TEMP_DIR}/mount-point\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\""
}

test_find_based_collector_empty_output_file_fail()
{
  assertFalse "_find_based_collector \
    \"find\" \
    \"${__TEST_TEMP_DIR}/mount-point\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"${__TEST_TEMP_DIR}/destination_directory\" \
    \"\""
}

test_find_based_collector_invalid_file_list_fail()
{
  assertFalse "_find_based_collector \
    \"find\" \
    \"invalid_file.txt\" \
    \"true\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"${__TEST_TEMP_DIR}/destination_directory\" \
    \"test_find_based_collector_invalid_file_list_fail.txt\""

    assertFalse "_find_based_collector \
    \"find\" \
    \"${__TEST_TEMP_DIR}/invalid_file.txt\" \
    \"true\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"${__TEST_TEMP_DIR}/destination_directory\" \
    \"test_find_based_collector_invalid_file_list_fail.txt\""
}

test_find_based_collector_no_hashing_tool_fail()
{
  __UAC_TOOL_MD5_BIN=""
  __UAC_TOOL_SHA1_BIN=""
  __UAC_TOOL_SHA256_BIN=""
  __UAC_CONF_HASH_ALGORITHM="md5|sha1|sha256"

  assertTrue "_find_based_collector \
    \"hash\" \
    \"/\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"${__TEST_TEMP_DIR}/destination_directory\" \
    \"test_find_based_collector_no_hashing_tool_fail.txt\""

  __UAC_CONF_HASH_ALGORITHM="sha1|sha256"
  
  assertTrue "_find_based_collector \
    \"hash\" \
    \"/\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"${__TEST_TEMP_DIR}/destination_directory\" \
    \"test_find_based_collector_no_hashing_tool_fail.txt\""

  __UAC_CONF_HASH_ALGORITHM="sha256"
  
  assertTrue "_find_based_collector \
    \"hash\" \
    \"/\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"${__TEST_TEMP_DIR}/destination_directory\" \
    \"test_find_based_collector_no_hashing_tool_fail.txt\""
}

test_find_based_collector_no_stat_tool_fail()
{
  __UAC_TOOL_STAT_BIN=""

  assertFalse "_find_based_collector \
    \"stat\" \
    \"/\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"\" \
    \"${__TEST_TEMP_DIR}/destination_directory\" \
    \"test_find_based_collector_no_stat_tool_fail.txt\""
}

test_find_based_collector_simple_find_success()
{
  __test_actual=`_find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_success_find.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_success_find.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"
}

test_find_based_collector_file_is_file_list_success()
{
  __test_actual=`_find_based_collector \
    "file" \
    "${__TEST_TEMP_DIR}/uac/file_list.txt" \
    "true" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_file_is_file_list_absolute_path_success.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_file_is_file_list_absolute_path_success.txt"`
  assertEquals "cat \"${__TEST_TEMP_DIR}/uac/file_list.txt\"" "${__test_actual}"

  __test_actual=`_find_based_collector \
    "file" \
    "file_list.txt" \
    "true" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_file_is_file_list_relative_file_path_success.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_file_is_file_list_relative_file_path_success.txt"`
  assertEquals "cat \"${__TEST_TEMP_DIR}/collected/file_list.txt\"" "${__test_actual}"

  __test_actual=`_find_based_collector \
    "file" \
    "destination_directory/file_list.txt" \
    "true" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_file_is_file_list_relative_directory_path_success.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_file_is_file_list_relative_directory_path_success.txt"`
  assertEquals "cat \"${__TEST_TEMP_DIR}/collected/destination_directory/file_list.txt\"" "${__test_actual}"
}

test_find_based_collector_simple_file_success()
{
  __test_actual=`_find_based_collector \
    "file" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_success_file.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_success_file.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"
}

test_find_based_collector_hash_is_file_list_success()
{
  __test_actual=`_find_based_collector \
    "hash" \
    "${__TEST_TEMP_DIR}/uac/file_list.txt" \
    "true" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_is_file_list_absolute_path_success.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_is_file_list_absolute_path_success.txt.md5"`
  assertEquals "sed 's|.|\\\\&|g' \"${__TEST_TEMP_DIR}/uac/file_list.txt\" | xargs md5sum" "${__test_actual}"

  __test_actual=`_find_based_collector \
    "hash" \
    "file_list.txt" \
    "true" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_is_file_list_relative_file_path_success.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_is_file_list_relative_file_path_success.txt.md5"`
  assertEquals "sed 's|.|\\\\&|g' \"${__TEST_TEMP_DIR}/collected/file_list.txt\" | xargs md5sum" "${__test_actual}"

  __test_actual=`_find_based_collector \
    "hash" \
    "destination_directory/file_list.txt" \
    "true" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_is_file_list_relative_directory_path_success.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_is_file_list_relative_directory_path_success.txt.md5"`
  assertEquals "sed 's|.|\\\\&|g' \"${__TEST_TEMP_DIR}/collected/destination_directory/file_list.txt\" | xargs md5sum" "${__test_actual}"
  
}

test_find_based_collector_hash_print0_success()
{
  __test_actual=`_find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_print0_success.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_print0_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_print0_success.txt.sha1"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 sha1sum" "${__test_actual}"

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_print0_success.txt.sha256"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 sha256sum" "${__test_actual}"
}

test_find_based_collector_hash_no_print0_success()
{
  __UAC_TOOL_FIND_PRINT0_SUPPORT=false
  __UAC_TOOL_XARGS_NULL_DELIMITER_SUPPORT=true

  __test_actual=`_find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_no_print0_success.txt"`

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_no_print0_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\" | sed 's|.|\\\\&|g' | xargs md5sum" "${__test_actual}"

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_no_print0_success.txt.sha1"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\" | sed 's|.|\\\\&|g' | xargs sha1sum" "${__test_actual}"

  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_no_print0_success.txt.sha256"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\" | sed 's|.|\\\\&|g' | xargs sha256sum" "${__test_actual}"
}


test_find_based_collector_stat_is_file_list_success()
{
  __test_actual=`_find_based_collector \
    "stat" \
    "${__TEST_TEMP_DIR}/uac/file_list.txt" \
    "true" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_is_file_list_absolute_path_success.txt"`

  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_is_file_list_absolute_path_success.txt"`
  assertEquals "sed 's|.|\\\\&|g' \"${__TEST_TEMP_DIR}/uac/file_list.txt\" | xargs stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"

  __test_actual=`_find_based_collector \
    "stat" \
    "file_list.txt" \
    "true" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_is_file_list_relative_file_path_success.txt"`

  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_is_file_list_relative_file_path_success.txt"`
  assertEquals "sed 's|.|\\\\&|g' \"${__TEST_TEMP_DIR}/collected/file_list.txt\" | xargs stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"

  __test_actual=`_find_based_collector \
    "stat" \
    "destination_directory/file_list.txt" \
    "true" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_is_file_list_relative_directory_path_success.txt"`

  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_is_file_list_relative_directory_path_success.txt"`
  assertEquals "sed 's|.|\\\\&|g' \"${__TEST_TEMP_DIR}/collected/destination_directory/file_list.txt\" | xargs stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
  
}

test_find_based_collector_stat_print0_success()
{
  __test_actual=`_find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_print0_success.txt"`

  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_print0_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"

}

test_find_based_collector_stat_no_print0_success()
{
  __UAC_TOOL_FIND_PRINT0_SUPPORT=true
  __UAC_TOOL_XARGS_NULL_DELIMITER_SUPPORT=false

  __test_actual=`_find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_no_print0_success.txt"`

  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_no_print0_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\" | sed 's|.|\\\\&|g' | xargs stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"

}

test_find_based_collector_path_pattern_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_path_pattern_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_path_pattern_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"/usr|/etc/default|/proc\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_path_pattern_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_path_pattern_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"/usr|/etc/default|/proc\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_path_pattern_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_path_pattern_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"/usr|/etc/default|/proc\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_name_pattern_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "*.txt|*.sh" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_name_pattern_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_name_pattern_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"*.txt|*.sh\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "*.txt|*.sh" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_name_pattern_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_name_pattern_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"*.txt|*.sh\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "*.txt|*.sh" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_name_pattern_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_name_pattern_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"*.txt|*.sh\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_exclude_path_pattern_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_exclude_path_pattern_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_exclude_path_pattern_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"/usr|/etc/default|/proc|${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_exclude_path_pattern_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_exclude_path_pattern_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"/usr|/etc/default|/proc|${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  __UAC_CONF_EXCLUDE_PATH_PATTERN="/tmp|/var/tmp"
  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_exclude_path_pattern_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_exclude_path_pattern_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"/usr|/etc/default|/proc|/tmp|/var/tmp|${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_exclude_name_pattern_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "*.txt|*.sh" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_exclude_name_pattern_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_exclude_name_pattern_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"*.txt|*.sh\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "*.txt|*.sh" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_exclude_name_pattern_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_exclude_name_pattern_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"*.txt|*.sh\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  __UAC_CONF_EXCLUDE_NAME_PATTERN="*.jpg|*.log"
  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "*.txt|*.sh" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_exclude_name_pattern_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_exclude_name_pattern_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"*.txt|*.sh|*.jpg|*.log\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_exclude_file_system_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "apfs|ntfs" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_exclude_file_system_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_exclude_file_system_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"/apfs|/mnt/ntfs|${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "apfs|ntfs" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_exclude_file_system_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_exclude_file_system_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"/apfs|/mnt/ntfs|${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  __UAC_EXCLUDE_MOUNT_POINTS="/tmp|/run/tmp"
  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "apfs|ntfs" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_exclude_file_system_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_exclude_file_system_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"/apfs|/mnt/ntfs|/tmp|/run/tmp|${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_maxdepth_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_maxdepth_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_maxdepth_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"10\" \"\" \"\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_maxdepth_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_maxdepth_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"10\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_maxdepth_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_maxdepth_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"10\" \"\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_file_type_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "d" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_file_type_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_file_type_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"d\" \"\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "d" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_file_type_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_file_type_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"d\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "d" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_file_type_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_file_type_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"d\" \"\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_min_file_size_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "1024" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_min_file_size_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_min_file_size_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"1024\" \"\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "1024" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_min_file_size_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_min_file_size_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"1024\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "1024" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_min_file_size_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_min_file_size_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"1024\" \"\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_max_file_size_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "2048" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_max_file_size_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_max_file_size_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"2048\" \"\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "2048" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_max_file_size_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_max_file_size_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"2048\" \"\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "2048" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_max_file_size_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_max_file_size_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"2048\" \"\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_permissions_success()
{
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "755" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_permissions_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_permissions_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"755\" \"false\" \"0\" \"0\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "755" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_permissions_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_permissions_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"755\" \"true\" \"0\" \"0\" | xargs -0 md5sum" "${__test_actual}"

  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "755" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_permissions_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_permissions_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"755\" \"true\" \"0\" \"0\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}

test_find_based_collector_ignore_date_range_success()
{
  __UAC_START_DATE_DAYS=20
  __UAC_END_DATE_DAYS=10
  _find_based_collector \
    "find" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_find_ignore_date_range_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_find_ignore_date_range_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"false\" \"20\" \"10\"" "${__test_actual}"

  _find_based_collector \
    "hash" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_hash_ignore_date_range_success.txt"
  __test_actual=`cat "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_hash_ignore_date_range_success.txt.md5"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"20\" \"10\" | xargs -0 md5sum" "${__test_actual}"

  _find_based_collector \
    "stat" \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "${__TEST_TEMP_DIR}/destination_directory" \
    "test_find_based_collector_stat_ignore_date_range_success.txt"
  __test_actual=`sed -e 's:|0:|%W":g' "${__TEST_TEMP_DIR}/destination_directory/test_find_based_collector_stat_ignore_date_range_success.txt"`
  assertEquals "_build_find_command \"${__TEST_TEMP_DIR}/mount-point//\" \"\" \"\" \"${__TEST_TEMP_DIR}/uac|${__TEST_TEMP_DIR}\" \"\" \"\" \"\" \"\" \"\" \"\" \"true\" \"20\" \"10\" | xargs -0 stat -c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__test_actual}"
}
