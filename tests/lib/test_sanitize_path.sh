#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/sanitize_path.sh"
}

test_sanitize_path_root_success()
{
  __test_actual=`_sanitize_path "/"`
  assertEquals "/" "${__test_actual}"
}

test_sanitize_path_var_log_success()
{
  __test_actual=`_sanitize_path "/var/log"`
  assertEquals "/var/log" "${__test_actual}"
}

test_sanitize_path_dot_dot_var_log_success()
{
  __test_actual=`_sanitize_path "../var/log"`
  assertEquals "./var/log" "${__test_actual}"
  __test_actual=`_sanitize_path "../../var/log"`
  assertEquals "././var/log" "${__test_actual}"
  __test_actual=`_sanitize_path "/var/../log"`
  assertEquals "/var/./log" "${__test_actual}"
  __test_actual=`_sanitize_path "/var/../../../../log"`
  assertEquals "/var/././././log" "${__test_actual}"
  __test_actual=`_sanitize_path "/var/log/.."`
  assertEquals "/var/log/." "${__test_actual}"
}

test_sanitize_path_double_slash_success()
{
  __test_actual=`_sanitize_path "//var/log"`
  assertEquals "/var/log" "${__test_actual}"
  __test_actual=`_sanitize_path "//var///log"`
  assertEquals "/var/log" "${__test_actual}"
  __test_actual=`_sanitize_path "//"`
  assertEquals "/" "${__test_actual}"
}

test_sanitize_path_leading_trailing_spaces_success()
{
  __test_actual=`_sanitize_path "  /var/log     "`
  assertEquals "/var/log" "${__test_actual}"
}

test_sanitize_path_trailing_slash_success()
{
  __test_actual=`_sanitize_path "/var/log/"`
  assertEquals "/var/log" "${__test_actual}"
  __test_actual=`_sanitize_path "/var/log//"`
  assertEquals "/var/log" "${__test_actual}"
  __test_actual=`_sanitize_path "/var/log///"`
  assertEquals "/var/log" "${__test_actual}"
}

test_sanitize_path_empty_path_success()
{
  __test_actual=`_sanitize_path ""`
  assertEquals "/" "${__test_actual}"
}
