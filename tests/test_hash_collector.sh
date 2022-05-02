#!/bin/sh

# shellcheck disable=SC2034

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_hash_collector"
  mkdir -p "${TEMP_DATA_DIR}"
  UAC_LOG_FILE="${TEMP_DATA_DIR}/uac.log"

  echo "${MOUNT_POINT}/etc/issue" >>"${TEMP_DATA_DIR}/source_file.txt"
  echo "${MOUNT_POINT}/etc/default/keyboard" >>"${TEMP_DATA_DIR}/source_file.txt"
}

shutdown_test() {
  return 0
}

before_each_test() {
  GLOBAL_EXCLUDE_MOUNT_POINT=""
  GLOBAL_EXCLUDE_NAME_PATTERN=""
  GLOBAL_EXCLUDE_PATH_PATTERN=""
  START_DATE_DAYS=""
  END_DATE_DAYS=""

  ENABLE_FIND_ATIME=false
  ENABLE_FIND_MTIME=true
  ENABLE_FIND_CTIME=false

  HASH_ALGORITHM="md5"
}

after_each_test() {
  return 0
}

test_path() {
  hash_collector \
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
    "root_directory" \
    "" \
    "path_output_file.txt"
  assert_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/path_output_file.txt.md5"
}

test_empty_path() {
  assert_fails "hash_collector \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" 2>/dev/null"
}

test_path_with_white_spaces() {
  hash_collector \
    "/etc/\"white space\"" \
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
    "root_directory" \
    "" \
    "path_with_white_spaces_output_file.txt"
  assert_matches_file_content "1c9450a30cea35865b10519e59f31e3e" "${TEMP_DATA_DIR}/root_directory/path_with_white_spaces_output_file.txt.md5"
}

test_path_with_double_quotes() {
  hash_collector \
    "/etc/double\\\"quotes" \
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
    "root_directory" \
    "" \
    "path_with_double_quotes_output_file.txt"
  assert_matches_file_content "95f7cb0a18169634db6a0d30cc30e287" "${TEMP_DATA_DIR}/root_directory/path_with_double_quotes_output_file.txt.md5"
}

test_file_list_absolute_path() {
  hash_collector \
    "${TEMP_DATA_DIR}/source_file.txt" \
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
    "root_directory" \
    "" \
    "file_list_absolute_path_output_file.txt"
  assert_matches_file_content "8d8274be55beb805e21db30e20601c89" "${TEMP_DATA_DIR}/root_directory/file_list_absolute_path_output_file.txt.md5"
}

test_file_list_relative_path() {
  echo "${MOUNT_POINT}/etc/issue" >>"${TEMP_DATA_DIR}/root_directory/source_file.txt"
  echo "${MOUNT_POINT}/etc/default/keyboard" >>"${TEMP_DATA_DIR}/root_directory/source_file.txt"

  hash_collector \
    "source_file.txt" \
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
    "root_directory" \
    "" \
    "file_list_relative_path_output_file.txt"
  assert_matches_file_content "8d8274be55beb805e21db30e20601c89" "${TEMP_DATA_DIR}/root_directory/file_list_relative_path_output_file.txt.md5"
}

test_path_pattern_usr_lib() {
  hash_collector \
    "/" \
    "" \
    "*/usr/lib/*,*/etc/*" \
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
    "root_directory" \
    "" \
    "path_pattern_output_file.txt"
  assert_matches_file_content "844e7199b251dc8d08df5f87ec686e1e" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt.md5"
}

test_path_pattern_etc() {
  assert_matches_file_content "8d8274be55beb805e21db30e20601c89" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt.md5"
}

test_path_pattern_find_operators_support() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "b026324c6904b2a9cb4b88d6d61c81d1" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt.md5"
  else
    assert_matches_file_content "b026324c6904b2a9cb4b88d6d61c81d1" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt.md5"
  fi
}

test_path_pattern_with_white_spaces() {
  hash_collector \
    "/" \
    "" \
    "*white space*" \
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
    "root_directory" \
    "" \
    "path_pattern_with_white_spaces_output_file.txt"
  assert_matches_file_content "1c9450a30cea35865b10519e59f31e3e" "${TEMP_DATA_DIR}/root_directory/path_pattern_with_white_spaces_output_file.txt.md5"
}

test_name_pattern_so() {
  hash_collector \
    "/" \
    "" \
    "" \
    "*.so.*,*.sh" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "root_directory" \
    "" \
    "name_pattern_output_file.txt"
  assert_matches_file_content "844e7199b251dc8d08df5f87ec686e1e" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt.md5"
}

test_name_pattern_sh() {
  assert_matches_file_content "aa011930d295035d9c90eeb6be512af5" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt.md5"
}

test_name_pattern_find_operators_support() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "b026324c6904b2a9cb4b88d6d61c81d1" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt.md5"
  else
    assert_matches_file_content "b026324c6904b2a9cb4b88d6d61c81d1" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt.md5"
  fi
}

test_name_pattern_with_white_spaces() {
  hash_collector \
    "/" \
    "" \
    "" \
    "file name" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "root_directory" \
    "" \
    "name_pattern_with_white_spaces_output_file.txt"
  assert_matches_file_content "1c9450a30cea35865b10519e59f31e3e" "${TEMP_DATA_DIR}/root_directory/name_pattern_with_white_spaces_output_file.txt.md5"
}

test_exclude_path_pattern() {
  hash_collector \
    "/" \
    "" \
    "" \
    "" \
    "*/usr/lib/*,*/etc/*" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "root_directory" \
    "" \
    "exclude_path_pattern_output_file.txt"
  assert_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt.md5"
}

test_exclude_path_pattern_find_operators_support_usr_lib() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "844e7199b251dc8d08df5f87ec686e1e" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt.md5"
  else
    assert_matches_file_content "844e7199b251dc8d08df5f87ec686e1e" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt.md5"
  fi
}

test_exclude_path_pattern_find_operators_support_etc() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "df80a957c9fe8d5df511e9c0c5bbe97c" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt.md5"
  else
    assert_matches_file_content "df80a957c9fe8d5df511e9c0c5bbe97c" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt.md5"
  fi
}

test_exclude_name_pattern() {
  hash_collector \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "*.so.*,*.sh" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "root_directory" \
    "" \
    "exclude_name_pattern_output_file.txt"
  assert_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt.md5"
}

test_exclude_name_pattern_find_operators_support_so() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "844e7199b251dc8d08df5f87ec686e1e" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt.md5"
  else
    assert_matches_file_content "844e7199b251dc8d08df5f87ec686e1e" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt.md5"
  fi
}

test_exclude_name_pattern_find_operators_support_sh() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "aa011930d295035d9c90eeb6be512af5" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt.md5"
  else
    assert_matches_file_content "aa011930d295035d9c90eeb6be512af5" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt.md5"
  fi
}

test_max_depth() {
  hash_collector \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "2" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "root_directory" \
    "" \
    "max_depth_output_file.txt"
  assert_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/max_depth_output_file.txt.md5"
}

test_no_max_depth_support() {
  if ${FIND_MAXDEPTH_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "3194886894e788a8462462eab12e1738" "${TEMP_DATA_DIR}/root_directory/max_depth_output_file.txt.md5"
  else
    assert_matches_file_content "3194886894e788a8462462eab12e1738" "${TEMP_DATA_DIR}/root_directory/max_depth_output_file.txt.md5"
  fi
}

test_type() {
  hash_collector \
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
    "root_directory" \
    "" \
    "type_output_file.txt"
  assert_not_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/type_output_file.txt.md5"
}

test_min_file_size() {
  hash_collector \
    "/" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "40" \
    "" \
    "" \
    "" \
    "root_directory" \
    "" \
    "min_file_size_output_file.txt"
  assert_matches_file_content "ed9fbd6b98461aeb46c310c94c83c325" "${TEMP_DATA_DIR}/root_directory/min_file_size_output_file.txt.md5"
}

test_min_file_size_no_smaller_than_40b() {
  if ${FIND_SIZE_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/min_file_size_output_file.txt.md5"
  else
    assert_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/min_file_size_output_file.txt.md5"
  fi
}

test_max_file_size() {
  hash_collector \
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
    "40" \
    "" \
    "" \
    "root_directory" \
    "" \
    "max_file_size_output_file.txt"
  assert_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/max_file_size_output_file.txt.md5"
}

test_min_file_size_no_greater_than_40b() {
  if ${FIND_SIZE_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "ed9fbd6b98461aeb46c310c94c83c325" "${TEMP_DATA_DIR}/root_directory/max_file_size_output_file.txt.md5"
  else
    assert_matches_file_content "ed9fbd6b98461aeb46c310c94c83c325" "${TEMP_DATA_DIR}/root_directory/max_file_size_output_file.txt.md5"
  fi
}

test_perm() {
  hash_collector \
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
    "777" \
    "" \
    "root_directory" \
    "" \
    "perm_output_file.txt"
  assert_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/perm_output_file.txt.md5"
}

test_no_perm_support() {
  if ${FIND_PERM_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "3194886894e788a8462462eab12e1738" "${TEMP_DATA_DIR}/root_directory/perm_output_file.txt.md5"
  else
    assert_matches_file_content "3194886894e788a8462462eab12e1738" "${TEMP_DATA_DIR}/root_directory/perm_output_file.txt.md5"
  fi
}

test_ignore_date_range() {
  END_DATE_DAYS="10"
  hash_collector \
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
    "root_directory" \
    "" \
    "ignore_date_range_output_file.txt"
  assert_not_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/ignore_date_range_output_file.txt.md5"
}

test_ignore_date_range_true() {
  END_DATE_DAYS="10"
  hash_collector \
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
    "true" \
    "root_directory" \
    "" \
    "ignore_date_range_output_file.txt"
  assert_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/ignore_date_range_output_file.txt.md5"
}

test_output_directory() {
  hash_collector \
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
    "root_directory" \
    "output_directory" \
    "output_directory_output_file.txt"
  assert_matches_file_content "8b152d34433d29c0f678034b8f2f358a" "${TEMP_DATA_DIR}/root_directory/output_directory/output_directory_output_file.txt.md5"
}

test_sha1_algorithm() {
  HASH_ALGORITHM="sha1"

  if [ -n "${SHA1_HASHING_TOOL}" ]; then
    hash_collector \
      "/bin" \
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
      "root_directory" \
      "" \
      "path_output_file.txt"
    assert_matches_file_content "9c7169dd204698f0fa5490fa117826a30c331126" "${TEMP_DATA_DIR}/root_directory/path_output_file.txt.sha1"
  fi
}

test_sha256_algorithm() {
  HASH_ALGORITHM="sha256"

  if [ -n "${SHA256_HASHING_TOOL}" ]; then
    hash_collector \
      "/bin" \
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
      "root_directory" \
      "" \
      "path_output_file.txt"
    assert_matches_file_content "7d0ac3f078127faed1aff3ae1adccf9dce266457753d15d423324a8ccb55edb1" "${TEMP_DATA_DIR}/root_directory/path_output_file.txt.sha256"
  fi
}