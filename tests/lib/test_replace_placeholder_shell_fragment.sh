#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2016

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/replace_placeholder_shell_fragment.sh"
}

# ---------------------------------------------------------------------------
# Empty / edge cases
# ---------------------------------------------------------------------------

test_replace_placeholder_shell_fragment_returns_input_when_placeholder_empty()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "" "hello"`
  assertEquals "echo %X%" "${__test_actual}"
}

test_replace_placeholder_shell_fragment_returns_input_unchanged_when_no_match()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%Y%" "hello"`
  assertEquals "echo %X%" "${__test_actual}"
}

test_replace_placeholder_shell_fragment_empty_value_outside_quotes()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%X%" ""`
  assertEquals 'echo ""' "${__test_actual}"
}

test_replace_placeholder_shell_fragment_empty_value_inside_double_quotes()
{
  __test_actual=`_replace_placeholder_shell_fragment 'echo "%X%"' "%X%" ""`
  assertEquals 'echo ""' "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Unquoted context
# ---------------------------------------------------------------------------

test_replace_placeholder_shell_fragment_unquoted_plain_value()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%X%" "hello"`
  assertEquals 'echo "hello"' "${__test_actual}"
}

test_replace_placeholder_shell_fragment_unquoted_value_with_single_quotes()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%X%" "it's ok"`
  assertEquals "echo \"it's ok\"" "${__test_actual}"
}

test_replace_placeholder_shell_fragment_unquoted_value_with_dollar()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%X%" '$HOME'`
  assertEquals "echo \"\\\$HOME\"" "${__test_actual}"
}

test_replace_placeholder_shell_fragment_unquoted_value_with_backtick()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%X%" 'hello\`cmd\`'`
  assertEquals 'echo "hello\`cmd\`"' "${__test_actual}"
}

test_replace_placeholder_shell_fragment_unquoted_value_with_backslash()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%X%" 'a\\\\b'`
  assertEquals 'echo "a\\b"' "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Inside double quotes
# ---------------------------------------------------------------------------

test_replace_placeholder_shell_fragment_inside_dquotes_plain_value()
{
  __test_actual=`_replace_placeholder_shell_fragment 'echo "%X%"' "%X%" "hello"`
  assertEquals 'echo "hello"' "${__test_actual}"
}

test_replace_placeholder_shell_fragment_inside_dquotes_value_with_dollar()
{
  __test_actual=`_replace_placeholder_shell_fragment 'echo "%X%"' "%X%" 'hello $HOME'`
  assertEquals 'echo "hello \$HOME"' "${__test_actual}"
}

test_replace_placeholder_shell_fragment_inside_dquotes_value_with_double_quote()
{
  __test_actual=`_replace_placeholder_shell_fragment 'echo "  %ABC%  "' "%ABC%" 'double"quote'`
  assertEquals 'echo "  double\"quote  "' "${__test_actual}"
}

test_replace_placeholder_shell_fragment_inside_dquotes_value_with_subshell()
{
  __test_actual=`_replace_placeholder_shell_fragment 'sed -e "s|abc|%X%|g"' "%X%" '$(rm -rf /)'`
  assertEquals 'sed -e "s|abc|\$(rm -rf /)|g"' "${__test_actual}"
}

test_replace_placeholder_shell_fragment_inside_dquotes_single_quoted_region()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo \"hello '%X%'\"" "%X%" '$HOME'`
  assertEquals "echo \"hello '\\\$HOME'\"" "${__test_actual}"
}

test_replace_placeholder_shell_fragment_inside_dquotes_value_with_backtick()
{
  __test_actual=`_replace_placeholder_shell_fragment 'echo "%X%"' "%X%" 'cmd\`injection\`'`
  assertEquals 'echo "cmd\`injection\`"' "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Inside single quotes
# ---------------------------------------------------------------------------

test_replace_placeholder_shell_fragment_inside_squotes_value_verbatim()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo '%X%'" "%X%" '$HOME'`
  assertEquals "echo '\$HOME'" "${__test_actual}"
}

test_replace_placeholder_shell_fragment_inside_squotes_dquoted_region()
{
  __test_actual=`_replace_placeholder_shell_fragment 'echo '"'"'hello "%X%"'"'" "%X%" '$HOME'`
  assertEquals 'echo '"'"'hello "$HOME"'"'" "${__test_actual}"
}

test_replace_placeholder_shell_fragment_inside_squotes_subshell_verbatim()
{
  __test_actual=`_replace_placeholder_shell_fragment "sed -e 's|abc|%X%|g'" "%X%" '$(rm -rf /)'`
  assertEquals "sed -e 's|abc|\$(rm -rf /)|g'" "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Mixed quoting contexts
# ---------------------------------------------------------------------------

test_replace_placeholder_shell_fragment_mixed_dquoted_and_unquoted()
{
  __test_actual=`_replace_placeholder_shell_fragment 'echo "%X%" and %X%' "%X%" 'hello $HOME'`
  assertEquals 'echo "hello \$HOME" and "hello \$HOME"' "${__test_actual}"
}

test_replace_placeholder_shell_fragment_multiple_occurrences_unquoted()
{
  __test_actual=`_replace_placeholder_shell_fragment "cp %X% %X%" "%X%" "file"`
  assertEquals 'cp "file" "file"' "${__test_actual}"
}

test_replace_placeholder_shell_fragment_placeholder_adjacent_to_text()
{
  __test_actual=`_replace_placeholder_shell_fragment "pre%X%post" "%X%" "mid"`
  assertEquals 'pre"mid"post' "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Security: ensure injection characters are neutralised
# ---------------------------------------------------------------------------

test_replace_placeholder_shell_fragment_no_dollar_expansion_unquoted()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%X%" '$HOME'`
  assertContains "${__test_actual}" '\$HOME'
}

test_replace_placeholder_shell_fragment_no_backtick_execution_unquoted()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%X%" '\`id\`'`
    assertContains "${__test_actual}" '\`id\`'
}

test_replace_placeholder_shell_fragment_no_double_quote_break_unquoted()
{
  __test_actual=`_replace_placeholder_shell_fragment "echo %X%" "%X%" 'a"b'`
  assertContains "${__test_actual}" '\"'
}
