#!/bin/sh

# shellcheck disable=SC2034

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_stat_collector"
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
}

after_each_test() {
  return 0
}

test_path() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/path_output_file.txt"
}

test_empty_path() {
  assert_fails "stat_collector \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" 2>/dev/null"
}

test_path_with_white_spaces() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/etc/white space\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/path_with_white_spaces_output_file.txt"
}

test_path_with_double_quotes() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/etc/double\"quotes\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/path_with_double_quotes_output_file.txt"
}

test_file_list_absolute_path() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/file_list_absolute_path_output_file.txt"
}

test_file_list_relative_path() {
  echo "${MOUNT_POINT}/etc/issue" >>"${TEMP_DATA_DIR}/root_directory/source_file.txt"
  echo "${MOUNT_POINT}/etc/default/keyboard" >>"${TEMP_DATA_DIR}/root_directory/source_file.txt"

  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/file_list_relative_path_output_file.txt"
}

test_path_pattern_usr_lib() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/usr/lib/library.so.1\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt"
}

test_path_pattern_etc() {
  assert_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt"
}

test_path_pattern_find_operators_support() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt"
  fi
}

test_path_pattern_with_white_spaces() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/etc/white space\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/path_pattern_with_white_spaces_output_file.txt"
}

test_name_pattern_so() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/usr/lib/library.so.1\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt"
}

test_name_pattern_sh() {
  assert_matches_file_content "^0\|${MOUNT_POINT}/bin/gpg.sh\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt"
}

test_name_pattern_find_operators_support() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt"
  fi
}

test_name_pattern_with_white_spaces() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/etc/white space/file name\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/name_pattern_with_white_spaces_output_file.txt"
}

test_exclude_path_pattern() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
}

test_exclude_path_pattern_find_operators_support_usr_lib() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/usr/lib/library.so.1\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/usr/lib/library.so.1\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
  fi
}

test_exclude_path_pattern_find_operators_support_etc() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
  fi
}

test_exclude_name_pattern() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
}

test_exclude_name_pattern_find_operators_support_so() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/usr/lib/library.so.1\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/usr/lib/library.so.1\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
  fi
}

test_exclude_name_pattern_find_operators_support_sh() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/bin/gpg.sh\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/bin/gpg.sh\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
  fi
}

test_max_depth() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/max_depth_output_file.txt"
}

test_no_max_depth_support() {
  if ${FIND_MAXDEPTH_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/usr/lib/library.so.1\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/max_depth_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/usr/lib/library.so.1\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/max_depth_output_file.txt"
  fi
}

test_type() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/usr/lib\|[0-9]*\|d.........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/type_output_file.txt"
}

test_min_file_size() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/bin/fiftyb\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/min_file_size_output_file.txt"
}

test_min_file_size_no_smaller_than_40b() {
  if ${FIND_SIZE_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/min_file_size_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/min_file_size_output_file.txt"
  fi
}

test_max_file_size() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/max_file_size_output_file.txt"
}

test_min_file_size_no_greater_than_40b() {
  if ${FIND_SIZE_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/bin/fiftyb\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/max_file_size_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/bin/fiftyb\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/max_file_size_output_file.txt"
  fi
}

test_perm() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/bin/cp\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/perm_output_file.txt"
}

test_no_perm_support() {
  if ${FIND_PERM_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/perm_output_file.txt"
  else
    assert_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/perm_output_file.txt"
  fi
}

test_ignore_date_range() {
  END_DATE_DAYS="10"
  stat_collector \
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
  assert_not_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/ignore_date_range_output_file.txt"
}

test_ignore_date_range_true() {
  END_DATE_DAYS="10"
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/ignore_date_range_output_file.txt"
}

test_output_directory() {
  stat_collector \
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
  assert_matches_file_content "^0\|${MOUNT_POINT}/etc/issue\|[0-9]*\|..........\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*\|[0-9]*" "${TEMP_DATA_DIR}/root_directory/output_directory/output_directory_output_file.txt"
}
