#!/bin/sh

# shellcheck disable=SC2006

setup_test() {
  return 0
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

test_common_artifact_list() {
  _result=`sanitize_artifact_list "live_response/process/ps.yaml,live_response/process/lsof.yaml,!live_response/process/pstree.yaml"`
  assert_equals "${_result}" "live_response/process/ps.yaml,live_response/process/lsof.yaml,!live_response/process/pstree.yaml"
}

test_remove_dot_dot_slash() {
  _result=`sanitize_artifact_list "../live_response/process/ps.yaml,../live_response/process/lsof.yaml"`
  assert_equals "${_result}" "live_response/process/ps.yaml,live_response/process/lsof.yaml"
}

test_remove_dot_slash() {
  _result=`sanitize_artifact_list "./live_response/process/ps.yaml,./live_response/process/lsof.yaml"`
  assert_equals "${_result}" "live_response/process/ps.yaml,live_response/process/lsof.yaml"
}

test_replace_exclamation_mark_slash() {
  _result=`sanitize_artifact_list "!/live_response/process/ps.yaml,!/live_response/process/lsof.yaml"`
  assert_equals "${_result}" "!live_response/process/ps.yaml,!live_response/process/lsof.yaml"
}

test_remove_artifacts_directory() {
  _result=`sanitize_artifact_list "artifacts/live_response/process/ps.yaml,!./artifacts/live_response/process/lsof.yaml,../artifacts/live_response/process/pstree.yaml"`
  assert_equals "${_result}" "live_response/process/ps.yaml,!live_response/process/lsof.yaml,live_response/process/pstree.yaml"
}

test_remove_consecutive_slashes() {
  _result=`sanitize_artifact_list "live_response///process/ps.yaml,////live_response/process/lsof.yaml"`
  assert_equals "${_result}" "live_response/process/ps.yaml,/live_response/process/lsof.yaml"
}

test_remove_consecutive_commas() {
  _result=`sanitize_artifact_list "live_response/process/ps.yaml,,,,live_response/process/lsof.yaml"`
  assert_equals "${_result}" "live_response/process/ps.yaml,live_response/process/lsof.yaml"
}

test_remove_leading_trailing_commas() {
  _result=`sanitize_artifact_list ",,,live_response/process/ps.yaml,live_response/process/lsof.yaml,,,"`
  assert_equals "${_result}" "live_response/process/ps.yaml,live_response/process/lsof.yaml"
}

test_empty_filename() {
  _result=`sanitize_artifact_list ""`
  assert_equals "${_result}" ""
}