#!/bin/sh

# shellcheck disable=SC2006

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_sort_uniq_file"
  mkdir -p "${TEMP_DATA_DIR}"

  cat << EOF >"${TEMP_DATA_DIR}/sort_uniq_file.txt"
c
b
d
a
b
EOF
}

shutdown_test() {
  return 0
}

before_each_test() {
  return 0
}

after_each_test() {
  return 0
}

test_sort_uniq_file() {
  assert "sort_uniq_file \"${TEMP_DATA_DIR}/sort_uniq_file.txt\""
}

test_first_line_is_a() {
  _result=`head -1 "${TEMP_DATA_DIR}/sort_uniq_file.txt"`
  assert_matches "${_result}" "a"
}

test_last_line_is_d() {
  _result=`tail -1 "${TEMP_DATA_DIR}/sort_uniq_file.txt"`
  assert_matches "${_result}" "d"
}

test_uniq_b() {
  # shellcheck disable=SC2126
  _result=`grep -E "b" "${TEMP_DATA_DIR}/sort_uniq_file.txt" | wc -l | awk '{print $1}'`
  assert_matches "${_result}" "1"
}