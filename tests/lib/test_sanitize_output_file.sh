#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/sanitize_output_file.sh"
}

test_sanitize_output_file_root_success()
{
  __test_actual=`_sanitize_output_file "/"`
  assertEquals "_" "${__test_actual}"
}

test_sanitize_output_file_success()
{
  __test_actual=`_sanitize_output_file "abc"`
  assertEquals "abc" "${__test_actual}"
  __test_actual=`_sanitize_output_file "abc.txt"`
  assertEquals "abc.txt" "${__test_actual}"
}

test_sanitize_output_file_leading_trailing_white_spaces_success()
{
  __test_actual=`_sanitize_output_file "   abc.txt   "`
  assertEquals "abc.txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "   abc.t x t   "`
  assertEquals "abc.t x t" "${__test_actual}"
}

test_sanitize_output_file_leading_slash_success()
{
  __test_actual=`_sanitize_output_file "/abc.txt"`
  assertEquals "abc.txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "///abc.txt"`
  assertEquals "abc.txt" "${__test_actual}"
}

test_sanitize_output_file_trailing_slash_success()
{
  __test_actual=`_sanitize_output_file "abc.txt/"`
  assertEquals "abc.txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "abc.txt///"`
  assertEquals "abc.txt" "${__test_actual}"
}

test_sanitize_output_file_multiple_slash_success()
{
  __test_actual=`_sanitize_output_file "abc/txt"`
  assertEquals "abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "abc////txt"`
  assertEquals "abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "///abc////txt///"`
  assertEquals "abc_txt" "${__test_actual}"
}

test_sanitize_output_file_replace_invalid_character_star_success()
{
  __test_actual=`_sanitize_output_file "abc*txt"`
  assertEquals "abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "abc**txt"`
  assertEquals "abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "*abc*txt*"`
  assertEquals "_abc_txt_" "${__test_actual}"
}

test_sanitize_output_file_replace_invalid_character_question_mark_success()
{
  __test_actual=`_sanitize_output_file "abc?txt"`
  assertEquals "abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "abc??txt"`
  assertEquals "abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "?abc?txt?"`
  assertEquals "_abc_txt_" "${__test_actual}"
}

test_sanitize_output_file_replace_invalid_character_colon_success()
{
  __test_actual=`_sanitize_output_file "abc:txt"`
  assertEquals "abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "abc::txt"`
  assertEquals "abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file ":abc:txt:"`
  assertEquals "_abc_txt_" "${__test_actual}"
}

test_sanitize_output_file_replace_invalid_character_double_quote_success()
{
  __test_actual=`_sanitize_output_file "abc\"txt"`
  assertEquals "abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "abc\"\"txt"`
  assertEquals "abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "\"abc\"txt\""`
  assertEquals "_abc_txt_" "${__test_actual}"
}

test_sanitize_output_file_replace_invalid_character_left_single_angle_quotation_mark_success()
{
  __test_actual=`_sanitize_output_file "abc<txt"`
  assertEquals "abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "abc<<txt"`
  assertEquals "abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "<abc<txt<"`
  assertEquals "_abc_txt_" "${__test_actual}"
}

test_sanitize_output_file_replace_invalid_character_right_single_angle_quotation_mark_success()
{
  __test_actual=`_sanitize_output_file "abc>txt"`
  assertEquals "abc_txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file "abc>>txt"`
  assertEquals "abc__txt" "${__test_actual}"
  __test_actual=`_sanitize_output_file ">abc>txt>"`
  assertEquals "_abc_txt_" "${__test_actual}"
}

test_sanitize_output_file_empty_filename_success()
{
  __test_actual=`_sanitize_output_file ""`
  assertEquals "_" "${__test_actual}"
}
