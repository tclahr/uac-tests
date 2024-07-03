#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317,SC2153

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/setup_tools.sh"

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

  _get_mount_point_by_file_system()
  {
    printf %b "/mount-point-by-file-system"
  }

  _get_user_home_list()
  {
    printf %b "uac:/home/uac"
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_setup_tools"
  
  mkdir -p "${__TEST_TEMP_DIR}/uac/config"
  mkdir -p "${__TEST_TEMP_DIR}/mount-point"
  touch "${__TEST_TEMP_DIR}/uac/uac"
  touch "${__TEST_TEMP_DIR}/uac/config/uac.conf"

  __UAC_DIR="${__TEST_TEMP_DIR}/uac"
  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"
  __UAC_MOUNT_POINT="${__TEST_TEMP_DIR}/mount-point"
  __UAC_OPERATING_SYSTEM="${TEST_SYSTEM_OS:-aix}"

}

setUp()
{
  __UAC_TOOL_STAT_BIN=""
  __UAC_TOOL_STAT_PARAMS=""
  __UAC_TOOL_STAT_BTIME=false
  __UAC_CONF_XARGS_MAX_PROCS=""
  __UAC_MAX_THREADS="2"
  __UAC_TOOL_MD5_BIN=""
  __UAC_TOOL_SHA1_BIN=""
  __UAC_TOOL_SHA256_BIN=""

  statx()
  {
    return 1
  }

  stat()
  {
    return 1
  }

  stat_pl()
  {
    return 1
  }

}

test_setup_tools_statx_support()
{
  statx()
  {
    printf %b "0|/|256|drwxr-xr-x|0|0|142|1708348761|1705923260|1705923260|1678363903"
  }

  _setup_tools

  assertEquals "statx" "${__UAC_TOOL_STAT_BIN}"
  assertNull "${__UAC_TOOL_STAT_PARAMS}"
  asserTrue "${__UAC_TOOL_STAT_BTIME}"

}

test_setup_tools_stat_support()
{
  stat()
  {
    printf %b "0|/|256|drwxr-xr-x|0|0|142|1708348761|1705923260|1705923260|0"
  }

  _setup_tools

  assertEquals "stat" "${__UAC_TOOL_STAT_BIN}"
  assertEquals "-c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__UAC_TOOL_STAT_PARAMS}"
  asserFalse "${__UAC_TOOL_STAT_BTIME}"

}

test_setup_tools_stat_btime_support()
{
  stat()
  {
    printf %b "0|/|256|drwxr-xr-x|0|0|142|1708348761|1705923260|1705923260|1678363903"
  }

  _setup_tools

  assertEquals "stat" "${__UAC_TOOL_STAT_BIN}"
  assertEquals "-c \"0|%N|%i|%A|%u|%g|%s|%X|%Y|%Z|%W\"" "${__UAC_TOOL_STAT_PARAMS}"
  asserTrue "${__UAC_TOOL_STAT_BTIME}"

}

test_setup_tools_stat_pl_support()
{
  stat_pl()
  {
    printf %b "0|/|256|drwxr-xr-x|0|0|142|1708348761|1705923260|1705923260|1678363903"
  }

  _setup_tools

  assertEquals "stat_pl" "${__UAC_TOOL_STAT_BIN}"
  assertNull "${__UAC_TOOL_STAT_PARAMS}"
  asserFalse "${__UAC_TOOL_STAT_BTIME}"

}

