#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/sanitize_output_directory.sh"
}

test_sanitize_output_directory_root_success()
{
  __test_actual=`_sanitize_output_directory "/"`
  assertEquals "/" "${__test_actual}"
}

test_sanitize_output_directory_var_log_success()
{
  __test_actual=`_sanitize_output_directory "/var/log"`
  assertEquals "/var/log" "${__test_actual}"
}

test_sanitize_output_directory_dot_dot_var_log_success()
{
  __test_actual=`_sanitize_output_directory "../var/log"`
  assertEquals "./var/log" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "../../var/log"`
  assertEquals "././var/log" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/var/../log"`
  assertEquals "/var/./log" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/var/../../../../log"`
  assertEquals "/var/././././log" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/var/log/.."`
  assertEquals "/var/log/." "${__test_actual}"
}

test_sanitize_output_directory_double_slash_success()
{
  __test_actual=`_sanitize_output_directory "//var/log"`
  assertEquals "/var/log" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "//var///log"`
  assertEquals "/var/log" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "//"`
  assertEquals "/" "${__test_actual}"
}

test_sanitize_output_directory_leading_trailing_spaces_success()
{
  __test_actual=`_sanitize_output_directory "  /var/log     "`
  assertEquals "/var/log" "${__test_actual}"
}

test_sanitize_output_directory_trailing_slash_success()
{
  __test_actual=`_sanitize_output_directory "/var/log/"`
  assertEquals "/var/log" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/var/log//"`
  assertEquals "/var/log" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/var/log///"`
  assertEquals "/var/log" "${__test_actual}"
}

test_sanitize_output_directory_replace_invalid_character_star_success()
{
  __test_actual=`_sanitize_output_directory "/abc*txt"`
  assertEquals "/abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/abc**txt"`
  assertEquals "/abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/*abc*txt*"`
  assertEquals "/_abc_txt_" "${__test_actual}"
}

test_sanitize_output_directory_replace_invalid_character_question_mark_success()
{
  __test_actual=`_sanitize_output_directory "/abc?txt"`
  assertEquals "/abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/abc??txt"`
  assertEquals "/abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/?abc?txt?"`
  assertEquals "/_abc_txt_" "${__test_actual}"
}

test_sanitize_output_directory_replace_invalid_character_colon_success()
{
  __test_actual=`_sanitize_output_directory "/abc:txt"`
  assertEquals "/abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/abc::txt"`
  assertEquals "/abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/:abc:txt:"`
  assertEquals "/_abc_txt_" "${__test_actual}"
}

test_sanitize_output_directory_replace_invalid_character_double_quote_success()
{
  __test_actual=`_sanitize_output_directory "/abc\"txt"`
  assertEquals "/abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/abc\"\"txt"`
  assertEquals "/abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/\"abc\"txt\""`
  assertEquals "/_abc_txt_" "${__test_actual}"
}

test_sanitize_output_directory_replace_invalid_character_left_single_angle_quotation_mark_success()
{
  __test_actual=`_sanitize_output_directory "/abc<txt"`
  assertEquals "/abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/abc<<txt"`
  assertEquals "/abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/<abc<txt<"`
  assertEquals "/_abc_txt_" "${__test_actual}"
}

test_sanitize_output_directory_replace_invalid_character_right_single_angle_quotation_mark_success()
{
  __test_actual=`_sanitize_output_directory "/abc>txt"`
  assertEquals "/abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/abc>>txt"`
  assertEquals "/abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_directory "/>abc>txt>"`
  assertEquals "/_abc_txt_" "${__test_actual}"
}

test_sanitize_output_directory_empty_path_success()
{
  __test_actual=`_sanitize_output_directory ""`
  assertEquals "/" "${__test_actual}"
}
