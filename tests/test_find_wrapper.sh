#!/bin/sh

# shellcheck disable=SC2034

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_find_wrapper"
  mkdir -p "${TEMP_DATA_DIR}"
  UAC_LOG_FILE="${TEMP_DATA_DIR}/uac.log"
}

shutdown_test() {
  return 0
}

before_each_test() {
  ENABLE_FIND_ATIME=false
  ENABLE_FIND_MTIME=true
  ENABLE_FIND_CTIME=false
}

after_each_test() {
  return 0
}

test_path() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    >"${TEMP_DATA_DIR}/path_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/etc/issue" "${TEMP_DATA_DIR}/path_output_file.txt"
}

test_empty_path() {
  assert_fails "find_wrapper \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" \"\" 2>/dev/null"
}

test_path_with_white_spaces() {
  find_wrapper \
    "${MOUNT_POINT}/etc/\"white space\"" \
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
    >"${TEMP_DATA_DIR}/path_with_white_spaces_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/etc/white space/file name" "${TEMP_DATA_DIR}/path_with_white_spaces_output_file.txt"
}

test_path_with_double_quotes() {
  find_wrapper \
    "${MOUNT_POINT}/etc/double\\\"quotes" \
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
    >"${TEMP_DATA_DIR}/path_with_double_quotes_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/etc/double\"quotes/file\"name" "${TEMP_DATA_DIR}/path_with_double_quotes_output_file.txt"
}

test_path_pattern_usr_lib() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    >"${TEMP_DATA_DIR}/path_pattern_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/usr/lib/library" "${TEMP_DATA_DIR}/path_pattern_output_file.txt"
}

test_path_pattern_etc() {
  assert_matches_file_content "${MOUNT_POINT}/etc/default/keyboard" "${TEMP_DATA_DIR}/path_pattern_output_file.txt"
}

test_path_pattern_find_operators_support() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/proc" "${TEMP_DATA_DIR}/path_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/proc" "${TEMP_DATA_DIR}/path_pattern_output_file.txt"
  fi
}

test_path_pattern_with_white_spaces() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    >"${TEMP_DATA_DIR}/path_pattern_with_white_spaces_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/etc/white space/file name" "${TEMP_DATA_DIR}/path_pattern_with_white_spaces_output_file.txt"
}

test_name_pattern_so() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    >"${TEMP_DATA_DIR}/name_pattern_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/usr/lib/library.so.1" "${TEMP_DATA_DIR}/name_pattern_output_file.txt"
}

test_name_pattern_sh() {
  assert_matches_file_content "${MOUNT_POINT}/bin/gpg.sh" "${TEMP_DATA_DIR}/name_pattern_output_file.txt"
}

test_name_pattern_find_operators_support() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/proc" "${TEMP_DATA_DIR}/name_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/proc" "${TEMP_DATA_DIR}/name_pattern_output_file.txt"
  fi
}

test_name_pattern_with_white_spaces() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    >"${TEMP_DATA_DIR}/name_pattern_with_white_spaces_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/etc/white space/file name" "${TEMP_DATA_DIR}/name_pattern_with_white_spaces_output_file.txt"
}

test_exclude_path_pattern() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    >"${TEMP_DATA_DIR}/exclude_path_pattern_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/exclude_path_pattern_output_file.txt"
}

test_exclude_path_pattern_find_operators_support_usr_lib() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/usr/lib/library" "${TEMP_DATA_DIR}/exclude_path_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/usr/lib/library" "${TEMP_DATA_DIR}/exclude_path_pattern_output_file.txt"
  fi
}

test_exclude_path_pattern_find_operators_support_etc() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/etc/default/keyboard" "${TEMP_DATA_DIR}/exclude_path_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/etc/default/keyboard" "${TEMP_DATA_DIR}/exclude_path_pattern_output_file.txt"
  fi
}

test_exclude_name_pattern() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    >"${TEMP_DATA_DIR}/exclude_name_pattern_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/exclude_name_pattern_output_file.txt"
}

test_exclude_name_pattern_find_operators_support_so() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/usr/lib/library.so.1" "${TEMP_DATA_DIR}/exclude_name_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/usr/lib/library.so.1" "${TEMP_DATA_DIR}/exclude_name_pattern_output_file.txt"
  fi
}

test_exclude_name_pattern_find_operators_support_sh() {
  if ${FIND_OPERATORS_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/bin/gpg.sh" "${TEMP_DATA_DIR}/exclude_name_pattern_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/bin/gpg.sh" "${TEMP_DATA_DIR}/exclude_name_pattern_output_file.txt"
  fi
}

test_max_depth() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    "" \
    >"${TEMP_DATA_DIR}/max_depth_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/max_depth_output_file.txt"
}

test_no_max_depth_support() {
  if ${FIND_MAXDEPTH_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/usr/bin/host" "${TEMP_DATA_DIR}/max_depth_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/usr/bin/host" "${TEMP_DATA_DIR}/max_depth_output_file.txt"
  fi
}

test_type() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    "" \
    >"${TEMP_DATA_DIR}/type_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/bin" "${TEMP_DATA_DIR}/type_output_file.txt"
}

test_type_only_directories() {
  assert_not_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/type_output_file.txt"
}

test_min_file_size() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    "" \
    >"${TEMP_DATA_DIR}/min_file_size_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/bin/fiftyb" "${TEMP_DATA_DIR}/min_file_size_output_file.txt"
}

test_min_file_size_no_smaller_than_40b() {
  if ${FIND_SIZE_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/min_file_size_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/min_file_size_output_file.txt"
  fi
}

test_max_file_size() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    >"${TEMP_DATA_DIR}/max_file_size_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/max_file_size_output_file.txt"
}

test_min_file_size_no_greater_than_40b() {
  if ${FIND_SIZE_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/bin/fiftyb" "${TEMP_DATA_DIR}/max_file_size_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/bin/fiftyb" "${TEMP_DATA_DIR}/max_file_size_output_file.txt"
  fi
}

test_perm() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    "" \
    >"${TEMP_DATA_DIR}/perm_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/perm_output_file.txt"
}

test_no_perm_support() {
  if ${FIND_PERM_SUPPORT} || ${PERL_TOOL_AVAILABLE}; then
    assert_not_matches_file_content "${MOUNT_POINT}/usr/bin/host" "${TEMP_DATA_DIR}/perm_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/usr/bin/host" "${TEMP_DATA_DIR}/perm_output_file.txt"
  fi
}

test_date_range_start() {
  find_wrapper \
    "${MOUNT_POINT}" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "" \
    >"${TEMP_DATA_DIR}/date_range_start_output_file.txt" \
    2>/dev/null
  assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/date_range_start_output_file.txt"
}

test_date_range_end() {
  find_wrapper \
    "${MOUNT_POINT}" \
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
    "10" \
    >"${TEMP_DATA_DIR}/date_range_start_output_file.txt" \
    2>/dev/null
  if ${FIND_MTIME_SUPPORT}; then
    assert_not_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/date_range_start_output_file.txt"
  else
    assert_matches_file_content "${MOUNT_POINT}/bin/cp" "${TEMP_DATA_DIR}/date_range_start_output_file.txt"
  fi
}