#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/is_output_format_supported.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  command_exists()
  {
    __co_command="${1:-}"

    if [ -z "${__co_command}" ]; then
      return 1
    fi

    if eval type type >/dev/null 2>/dev/null; then
      eval type "${__co_command}" >/dev/null 2>/dev/null
    elif command >/dev/null 2>/dev/null; then
      command -v "${__co_command}" >/dev/null 2>/dev/null
    else
      which "${__co_command}" >/dev/null 2>/dev/null
    fi

  }

}

test_is_output_format_supported_invalid_format_fail()
{
  assertFalse "_is_output_format_supported \"nonexistent\" \"\""
}

test_is_output_format_supported_none_format_success()
{
  assertTrue "_is_output_format_supported \"none\" \"\""
  __test_actual=`_is_output_format_supported "none" ""`
  assertNull "${__test_actual}"
}

test_is_output_format_supported_tar_format_success()
{
  if commandExists "tar"; then
    if commandExists "gzip"; then
      assertTrue "_is_output_format_supported \"tar\" \"\""
      __test_actual=`_is_output_format_supported "tar" ""`
      assertEquals "tar.gz" "${__test_actual}"
    else
      assertTrue "_is_output_format_supported \"tar\" \"\""
      __test_actual=`_is_output_format_supported "tar" ""`
      assertEquals "tar" "${__test_actual}"
    fi
  else
    skipTest "no such file or directory: 'tar'"
  fi
}

test_is_output_format_supported_tar_format_fail()
{
  if commandExists "tar"; then
    skipTest "'tar' command available"
  else
    assertFalse "_is_output_format_supported \"tar\" \"\""
  fi
}

test_is_output_format_supported_zip_format_success()
{
  if commandExists "zip"; then
    assertTrue "_is_output_format_supported \"zip\" \"\""
    __test_actual=`_is_output_format_supported "zip" ""`
    assertEquals "zip" "${__test_actual}"
  else
    skipTest "no such file or directory: 'zip'"
  fi
}

test_is_output_format_supported_zip_format_fail()
{
  if commandExists "zip"; then
    skipTest "'zip' command available"
  else
    assertFalse "_is_output_format_supported \"zip\" \"\""
  fi
}
