#!/bin/sh

# shellcheck disable=SC2006

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_get_user_home_list"
  mkdir -p "${TEMP_DATA_DIR}"
}

shutdown_test() {
  return 0
}

before_each_test() {
  rm -f "${TEMP_DATA_DIR}/.user_home_list.tmp"
}

after_each_test() {
  return 0
}

test_get_user_home_list() {
  _result=`get_user_home_list`
  assert_matches "${_result}" "uac:/home/uac"
}

test_get_user_home_list_skip_non_interactive_shells() {
  _result=`get_user_home_list true`
  assert_not_matches "${_result}" "mdatp:/home/mdatp"
}

test_get_user_home_list_from_home_directory() {
  _result=`get_user_home_list`
  if [ "${OPERATING_SYSTEM}" = "macos" ]; then
    assert_matches "${_result}" "skeletor:/Users/skeletor"
  elif [ "${OPERATING_SYSTEM}" = "solaris" ]; then
    assert_matches "${_result}" "skeletor:/export/home/skeletor"
  else
    assert_matches "${_result}" "skeletor:/home/skeletor"
  fi
}

test_get_user_home_list_from_chrome_os() {
  _result=`get_user_home_list`
  if [ "${OPERATING_SYSTEM}" = "linux" ]; then
    assert_matches "${_result}" "shadow:/home/.shadow"
  else
    assert_not_matches "${_result}" "shadow:/home/.shadow"
  fi
}