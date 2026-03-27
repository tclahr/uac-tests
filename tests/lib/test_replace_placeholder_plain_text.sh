#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/replace_placeholder_plain_text.sh"
}

test_replace_placeholder_plain_text_replaces_single_placeholder()
{
  __test_actual=`_replace_placeholder_plain_text "hello %name%" "%name%" "world"`
  assertEquals "hello world" "${__test_actual}"
}

test_replace_placeholder_plain_text_replaces_placeholder_in_middle()
{
  __test_actual=`_replace_placeholder_plain_text "user: %user% logged in" "%user%" "alice"`
  assertEquals "user: alice logged in" "${__test_actual}"
}

test_replace_placeholder_plain_text_replaces_all_occurrences()
{
  __test_actual=`_replace_placeholder_plain_text "%x% plus %x% equals two" "%x%" "one"`
  assertEquals "one plus one equals two" "${__test_actual}"
}

test_replace_placeholder_plain_text_returns_input_when_placeholder_is_empty()
{
  __test_actual=`_replace_placeholder_plain_text "no change" "" "value"`
  assertEquals "no change" "${__test_actual}"
}

test_replace_placeholder_plain_text_returns_empty_when_input_is_empty()
{
  __test_actual=`_replace_placeholder_plain_text "" "%key%" "value"`
  assertEquals "" "${__test_actual}"
}

test_replace_placeholder_plain_text_replaces_with_empty_value()
{
  __test_actual=`_replace_placeholder_plain_text "remove %token% here" "%token%" ""`
  assertEquals "remove  here" "${__test_actual}"
}

test_replace_placeholder_plain_text_no_match_returns_input_unchanged()
{
  __test_actual=`_replace_placeholder_plain_text "no placeholder here" "%missing%" "value"`
  assertEquals "no placeholder here" "${__test_actual}"
}

test_replace_placeholder_plain_text_escapes_ampersand_in_value()
{
  __test_actual=`_replace_placeholder_plain_text "company: %name%" "%name%" "AT&T"`
  assertEquals "company: AT&T" "${__test_actual}"
}

test_replace_placeholder_plain_text_escapes_pipe_in_value()
{
  __test_actual=`_replace_placeholder_plain_text "cmd: %c%" "%c%" "grep|awk"`
  assertEquals "cmd: grep|awk" "${__test_actual}"
}

test_replace_placeholder_plain_text_handles_value_with_spaces()
{
  __test_actual=`_replace_placeholder_plain_text "greeting: %msg%" "%msg%" "hello world"`
  assertEquals "greeting: hello world" "${__test_actual}"
}

test_replace_placeholder_plain_text_handles_placeholder_at_start_of_input()
{
  __test_actual=`_replace_placeholder_plain_text "%prefix% rest of text" "%prefix%" "START"`
  assertEquals "START rest of text" "${__test_actual}"
}

test_replace_placeholder_plain_text_handles_placeholder_at_end_of_input()
{
  __test_actual=`_replace_placeholder_plain_text "text ends with %suffix%" "%suffix%" "END"`
  assertEquals "text ends with END" "${__test_actual}"
}

test_replace_placeholder_plain_text_handles_input_with_only_placeholder()
{
  __test_actual=`_replace_placeholder_plain_text "%only%" "%only%" "replaced"`
  assertEquals "replaced" "${__test_actual}"
}

test_replace_placeholder_plain_text_does_not_replace_partial_placeholder()
{
  __test_actual=`_replace_placeholder_plain_text "incomplete %token here" "%token%" "value"`
  assertEquals "incomplete %token here" "${__test_actual}"
}

test_replace_placeholder_plain_text_all_args_empty()
{
  __test_actual=`_replace_placeholder_plain_text "" "" ""`
  assertEquals "" "${__test_actual}"
}