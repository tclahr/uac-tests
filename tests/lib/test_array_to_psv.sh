#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/array_to_psv.sh"
}

test_array_to_psv_trim_leading_and_trailing_brackets_success()
{
  __test_string="  [ first,second,third,fourth   ]   "
  __test_actual=`echo "${__test_string}" | _array_to_psv`
  assertEquals "first|second|third|fourth" "${__test_actual}"
}

test_array_to_psv_trim_leading_and_trailing_white_space_success()
{
  __test_string="   first,second,third,fourth      "
  __test_actual=`echo "${__test_string}" | _array_to_psv`
  assertEquals "first|second|third|fourth" "${__test_actual}"
}

test_array_to_psv_remove_white_spaces_between_items_success()
{
  __test_string="   first   ,  second   ,   third  ,  fourth      "
  __test_actual=`echo "${__test_string}" | _array_to_psv`
  assertEquals "first|second|third|fourth" "${__test_actual}"
}

test_array_to_psv_remove_empty_items_success()
{
  __test_string=",first,,,,second,,,third,,fourth,fifth,"
  __test_actual=`echo "${__test_string}" | _array_to_psv`
  assertEquals "first|second|third|fourth|fifth" "${__test_actual}"
}

test_array_to_psv_sanitize_all_success()
{
  __test_string="   ,\"first  \",,,,'   second',,,   third   ,,fourth,fifth,   "
  __test_actual=`echo "${__test_string}" | _array_to_psv`
  assertEquals "first  |   second|third|fourth|fifth" "${__test_actual}"
}

test_array_to_psv_escaped_comma_success()
{
  __test_string="first,second,thi \, rd,\"fo\,urth\""
  __test_actual=`echo "${__test_string}" | _array_to_psv`
  assertEquals "first|second|thi , rd|fo,urth" "${__test_actual}"
}

test_array_to_psv_escaped_double_quote_success()
{
  __test_string="first,second,\"thi \\\" rd\",\"fo\,urth\""
  __test_actual=`echo "${__test_string}" | _array_to_psv`
  assertEquals "first|second|thi \\ rd|fo,urth" "${__test_actual}"
}

test_array_to_psv_empty_string_success()
{
  __test_string=""
  __test_actual=`echo "${__test_string}" | _array_to_psv`
  assertNull "${__test_actual}"
}