#!/bin/sh

# shellcheck disable=SC2034

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_find_collector"
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
  find_collector \
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
    "root_directory" \
    "" \
    "path_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/etc/issue" "${TEMP_DATA_DIR}/root_directory/path_output_file.txt"
}

test_empty_stderr_file_exists() {
  assert_file_not_exists "${TEMP_DATA_DIR}/root_directory/path_output_file.txt.stderr"
}

test_stderr_file_exists() {
  find_collector \
    "/__invalidpath" \
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
    "__invalidpath.txt" \
    ""
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/__invalidpath.txt.stderr"
}

test_empty_path() {
  assert_fails "find_collector \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" 2>/dev/null"
}

test_path_with_white_spaces() {
  find_collector \
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
    "root_directory" \
    "" \
    "path_with_white_spaces_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/etc/white space/file name" "${TEMP_DATA_DIR}/root_directory/path_with_white_spaces_output_file.txt"
}

test_path_with_double_quotes() {
  find_collector \
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
    "root_directory" \
    "" \
    "path_with_double_quotes_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/etc/double\"quotes/file\"name" "${TEMP_DATA_DIR}/root_directory/path_with_double_quotes_output_file.txt"
}

test_path_pattern_usr_lib() {
  find_collector \
    "/" \
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
    "path_pattern_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/usr/lib/library" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt"
}

test_path_pattern_etc() {
  assert_matches_file_content "${MOUNT_POINT}/etc/default/keyboard" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt"
}

test_path_pattern_find_operators_support() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/proc" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/proc" "${TEMP_DATA_DIR}/root_directory/path_pattern_output_file.txt"
  fi
}

test_path_pattern_with_white_spaces() {
  find_collector \
    "/" \
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
    "path_pattern_with_white_spaces_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/etc/white space/file name" "${TEMP_DATA_DIR}/root_directory/path_pattern_with_white_spaces_output_file.txt"
}

test_name_pattern_so() {
  find_collector \
    "/" \
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
    "name_pattern_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/usr/lib/library.so.1" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt"
}

test_name_pattern_sh() {
  assert_matches_file_content "${MOUNT_POINT}/bin/gpg.sh" "${TEMP_DATA_DIR}/root_directory/name_pattern_output_file.txt"
}

test_name_pattern_with_white_spaces() {
  find_collector \
    "/" \
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
    "name_pattern_with_white_spaces_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/etc/white space/file name" "${TEMP_DATA_DIR}/root_directory/name_pattern_with_white_spaces_output_file.txt"
}

test_exclude_path_pattern() {
  find_collector \
    "/" \
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
    "exclude_path_pattern_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
}

test_exclude_path_pattern_find_operators_support_usr_lib() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/usr/lib/library" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/usr/lib/library" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
  fi
}

test_exclude_path_pattern_find_operators_support_etc() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/etc/default/keyboard" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/etc/default/keyboard" "${TEMP_DATA_DIR}/root_directory/exclude_path_pattern_output_file.txt"
  fi
}

test_exclude_name_pattern() {
  find_collector \
    "/" \
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
    "exclude_name_pattern_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
}

test_exclude_name_pattern_find_operators_support_so() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/usr/lib/library.so.1" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/usr/lib/library.so.1" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
  fi
}

test_exclude_name_pattern_find_operators_support_sh() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/bin/gpg.sh" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/bin/gpg.sh" "${TEMP_DATA_DIR}/root_directory/exclude_name_pattern_output_file.txt"
  fi
}

# ***** ADD EXCLUDE FILE SYSTEM TEST *****

test_max_depth() {
  find_collector \
    "/" \
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
    "max_depth_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/max_depth_output_file.txt"
}

test_no_max_depth_support() {
  if ${FIND_MAXDEPTH_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/usr/bin/host" "${TEMP_DATA_DIR}/root_directory/max_depth_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/usr/bin/host" "${TEMP_DATA_DIR}/root_directory/max_depth_output_file.txt"
  fi
}

test_type() {
  find_collector \
    "/" \
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
    "type_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/bin" "${TEMP_DATA_DIR}/root_directory/type_output_file.txt"
}

test_type_only_directories() {
  assert_not_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/type_output_file.txt"
}

test_min_file_size() {
  find_collector \
    "/" \
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
    "min_file_size_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/bin/fiftyb" "${TEMP_DATA_DIR}/root_directory/min_file_size_output_file.txt"
}

test_min_file_size_no_smaller_than_40b() {
  if ${FIND_SIZE_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/min_file_size_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/min_file_size_output_file.txt"
  fi
}

test_max_file_size() {
  find_collector \
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
    "root_directory" \
    "" \
    "max_file_size_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/max_file_size_output_file.txt"
}

test_min_file_size_no_greater_than_40b() {
  if ${FIND_SIZE_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/bin/fiftyb" "${TEMP_DATA_DIR}/root_directory/max_file_size_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/bin/fiftyb" "${TEMP_DATA_DIR}/root_directory/max_file_size_output_file.txt"
  fi
}

test_perm() {
  find_collector \
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
    "777" \
    "" \
    "root_directory" \
    "" \
    "perm_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/perm_output_file.txt"
}

test_no_perm_support() {
  if ${FIND_PERM_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/usr/bin/host" "${TEMP_DATA_DIR}/root_directory/perm_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/usr/bin/host" "${TEMP_DATA_DIR}/root_directory/perm_output_file.txt"
  fi
}

test_ignore_date_range() {
  END_DATE_DAYS="10"
  find_collector \
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
    "root_directory" \
    "" \
    "ignore_date_range_output_file.txt" \
    ""
  if ${FIND_MTIME_SUPPORT}; then
    assert_file_not_exists "${TEMP_DATA_DIR}/root_directory/ignore_date_range_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/ignore_date_range_output_file.txt"
  fi
}

test_ignore_date_range_true() {
  END_DATE_DAYS="10"
  find_collector \
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
    "true" \
    "root_directory" \
    "" \
    "ignore_date_range_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/ignore_date_range_output_file.txt"
}

test_output_directory() {
  find_collector \
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
    "root_directory" \
    "output_directory" \
    "output_directory_output_file.txt" \
    ""
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/root_directory/output_directory/output_directory_output_file.txt"
}

test_stderr_output_file() {
  find_collector \
    "/__invalidpath" \
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
    "__invalidpath.txt" \
    "custom_stderr_output_file.stderr"
    assert_file_exists "${TEMP_DATA_DIR}/root_directory/custom_stderr_output_file.stderr"
}