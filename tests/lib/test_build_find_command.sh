#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/build_find_command.sh"

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

  _is_psv()
  {
    __ip_string="${1:-}"

    if echo "${__ip_string}" | grep -q -E "\|"; then
      return 0
    fi
    return 1
  }

  _log_msg()
  {
    __lm_level="${1:-INF}"
    __lm_message="${2:-}"

    printf %b "YYYYMMDD hh:mm:ss Z ${__lm_level} ${__lm_message}\n" \
      >>"${__TEST_TEMP_DIR}/test.log" \
      2>/dev/null
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_build_find_command"
 
  mkdir -p "${__TEST_TEMP_DIR}/mount-point"

}

setUp()
{
  __UAC_CONF_MAX_DEPTH=0
  __UAC_CONF_ENABLE_FIND_MTIME=true
  __UAC_CONF_ENABLE_FIND_ATIME=true
  __UAC_CONF_ENABLE_FIND_CTIME=true

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=true
  __UAC_TOOL_FIND_PATH_SUPPORT=true
  __UAC_TOOL_FIND_PRUNE_SUPPORT=true
  __UAC_TOOL_FIND_MAXDEPTH_SUPPORT=true
  __UAC_TOOL_FIND_TYPE_SUPPORT=true
  __UAC_TOOL_FIND_SIZE_SUPPORT=true
  __UAC_TOOL_FIND_PERM_SUPPORT=true
  __UAC_TOOL_FIND_MTIME_SUPPORT=true
  __UAC_TOOL_FIND_ATIME_SUPPORT=true
  __UAC_TOOL_FIND_CTIME_SUPPORT=true
  __UAC_TOOL_FIND_PRINT0_SUPPORT=true
}

test_build_find_command_path_success()
{
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
}

test_build_find_command_path_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc/default\" -o -path \"/proc\" \) -print" "${__test_actual}"

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc/default\" -o -path \"/proc\" \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/etc/default\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/proc\" -print; " "${__test_actual}"
  fi

  __UAC_TOOL_FIND_PATH_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print" "${__test_actual}"
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc/default\" -o -path \"/proc\" \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/etc/default\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/proc\" -print; " "${__test_actual}"
  fi

}

test_build_find_command_name_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -name \"*.txt\" -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt|*.html|z*" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -name \"*.txt\" -o -name \"*.html\" -o -name \"z*\" \) -print" "${__test_actual}"

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt|*.html|z*" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -name \"*.txt\" -o -name \"*.html\" -o -name \"z*\" \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -name \"*.txt\" -print; find ${__TEST_TEMP_DIR}/mount-point -name \"*.html\" -print; find ${__TEST_TEMP_DIR}/mount-point -name \"z*\" -print; " "${__test_actual}"
  fi

}

test_build_find_command_exclude_path_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" \) -prune -o -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc/default\" -o -path \"/proc\" \) -prune -o -print" "${__test_actual}"

  __UAC_TOOL_FIND_PRUNE_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" \) -prune -o -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc/default\" -o -path \"/proc\" \) -prune -o -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
  fi

  __UAC_TOOL_FIND_PATH_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" \) -prune -o -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr|/etc/default|/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc/default\" -o -path \"/proc\" \) -prune -o -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
  fi

}

test_build_find_command_exclude_name_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "*.txt" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -name \"*.txt\" \) -prune -o -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "*.txt|*.html|z*" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -name \"*.txt\" -o -name \"*.html\" -o -name \"z*\" \) -prune -o -print" "${__test_actual}"

  __UAC_TOOL_FIND_PRUNE_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "*.txt" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -name \"*.txt\" \) -prune -o -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "*.txt|*.html|z*" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -name \"*.txt\" -o -name \"*.html\" -o -name \"z*\" \) -prune -o -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
  fi

}

test_build_find_command_path_pattern_name_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr" \
    "*.txt" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -name \"*.txt\" -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc" \
    "*.txt" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) -name \"*.txt\" -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc" \
    "*.txt|*.html" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) \( -name \"*.txt\" -o -name \"*.html\" \) -print" "${__test_actual}"

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc" \
    "*.txt|*.html" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) \( -name \"*.txt\" -o -name \"*.html\" \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -name \"*.txt\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -name \"*.html\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/etc\" -name \"*.txt\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/etc\" -name \"*.html\" -print; " "${__test_actual}"
  fi

}

test_build_find_command_path_pattern_exclude_name_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr" \
    "" \
    "" \
    "*.txt" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" \( -name \"*.txt\" \) -prune -o -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc" \
    "" \
    "" \
    "*.txt" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) \( -name \"*.txt\" \) -prune -o -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc" \
    "" \
    "" \
    "*.txt|*.html" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) \( -name \"*.txt\" -o -name \"*.html\" \) -prune -o -print" "${__test_actual}"

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc" \
    "" \
    "" \
    "*.txt|*.html" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) \( -name \"*.txt\" -o -name \"*.html\" \) -prune -o -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/etc\" -print; " "${__test_actual}"
  fi

  __UAC_TOOL_FIND_PATH_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc" \
    "" \
    "" \
    "*.txt|*.html" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) \( -name \"*.txt\" -o -name \"*.html\" \) -prune -o -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/etc\" -print; " "${__test_actual}"
  fi

}

test_build_find_command_name_pattern_exclude_path_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt" \
    "/usr" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" \) -prune -o -name \"*.txt\" -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt" \
    "/usr|/etc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) -prune -o -name \"*.txt\" -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt|*.html" \
    "/usr|/etc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) -prune -o \( -name \"*.txt\" -o -name \"*.html\" \) -print" "${__test_actual}"

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt|*.html" \
    "/usr|/etc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) -prune -o \( -name \"*.txt\" -o -name \"*.html\" \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -name \"*.txt\" -print; find ${__TEST_TEMP_DIR}/mount-point -name \"*.html\" -print; " "${__test_actual}"
  fi

  __UAC_TOOL_FIND_PATH_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt|*.html" \
    "/usr|/etc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) -prune -o \( -name \"*.txt\" -o -name \"*.html\" \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -name \"*.txt\" -print; find ${__TEST_TEMP_DIR}/mount-point -name \"*.html\" -print; " "${__test_actual}"
  fi

}

test_build_find_command_exclude_path_pattern_exclude_name_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr" \
    "*.txt" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" \) -prune -o \( -name \"*.txt\" \) -prune -o -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr|/etc" \
    "*.txt" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) -prune -o \( -name \"*.txt\" \) -prune -o -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr|/etc" \
    "*.txt|*.html" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) -prune -o \( -name \"*.txt\" -o -name \"*.html\" \) -prune -o -print" "${__test_actual}"

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __UAC_TOOL_FIND_PATH_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "/usr|/etc" \
    "*.txt|*.html" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/usr\" -o -path \"/etc\" \) -prune -o \( -name \"*.txt\" -o -name \"*.html\" \) -prune -o -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
  fi

}

test_build_find_command_path_pattern_exclude_path_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr" \
    "" \
    "/etc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/etc\" \) -prune -o -path \"/usr\" -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc/default|/proc" \
    "" \
    "/proc|/run" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -path \"/proc\" -o -path \"/run\" \) -prune -o \( -path \"/usr\" -o -path \"/etc/default\" -o -path \"/proc\" \) -print" "${__test_actual}"

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc/default|/proc" \
    "" \
    "/proc|/run" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/proc\" -o -path \"/run\" \) -prune -o \( -path \"/usr\" -o -path \"/etc/default\" -o -path \"/proc\" \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/etc/default\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/proc\" -print; " "${__test_actual}"
  fi

  __UAC_TOOL_FIND_PATH_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr" \
    "" \
    "/proc" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/proc\" \) -prune -o -path \"/usr\" -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print" "${__test_actual}"
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "/usr|/etc/default|/proc" \
    "" \
    "/proc|/run" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -path \"/proc\" -o -path \"/run\" \) -prune -o \( -path \"/usr\" -o -path \"/etc/default\" -o -path \"/proc\" \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -path \"/usr\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/etc/default\" -print; find ${__TEST_TEMP_DIR}/mount-point -path \"/proc\" -print; " "${__test_actual}"
  fi

}

test_build_find_command_name_pattern_exclude_name_pattern_success()
{  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt" \
    "" \
    "*.gz" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -name \"*.gz\" \) -prune -o -name \"*.txt\" -print" "${__test_actual}"

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt|*.html|z*" \
    "" \
    "*.gz|*.zip" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -name \"*.gz\" -o -name \"*.zip\" \) -prune -o \( -name \"*.txt\" -o -name \"*.html\" -o -name \"z*\" \) -print" "${__test_actual}"

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "*.txt|*.html|z*" \
    "" \
    "*.gz|*.zip" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -name \"*.gz\" -o -name \"*.zip\" \) -prune -o \( -name \"*.txt\" -o -name \"*.html\" -o -name \"z*\" \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -name \"*.txt\" -print; find ${__TEST_TEMP_DIR}/mount-point -name \"*.html\" -print; find ${__TEST_TEMP_DIR}/mount-point -name \"z*\" -print; " "${__test_actual}"
  fi

}

test_build_find_command_file_type_success()
{
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "f" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -type f -print" "${__test_actual}" 

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "f|d" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -type f -o -type d \) -print" "${__test_actual}"

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "f|d" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -type f -o -type d \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -type f -print; find ${__TEST_TEMP_DIR}/mount-point -type d -print; " "${__test_actual}"
  fi

  __UAC_TOOL_FIND_TYPE_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "f" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -type f -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "f|d" \
    "" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -type f -o -type d \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}"
  fi

}

test_build_find_command_min_file_size_success()
{
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "100" \
    "" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -size +100c -print" "${__test_actual}" 
  
  __UAC_TOOL_FIND_SIZE_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "100" \
    "" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -size +100c -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi

}

test_build_find_command_max_file_size_success()
{
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "200" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -size -200c -print" "${__test_actual}" 
  
  __UAC_TOOL_FIND_SIZE_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "200" \
    "" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -size -200c -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi
}

test_build_find_command_min_and_max_file_size_success()
{
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "100" \
    "200" \
    "" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -size +100c -size -200c -print" "${__test_actual}" 

  __UAC_TOOL_FIND_SIZE_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "100" \
    "200" \
    "" \
    "" \
    "" \
    ""`
  
  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -size +100c -size -200c -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi
  
}

test_build_find_command_perm_success()
{
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "777" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -perm 777 -print" "${__test_actual}" 

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "777|444" \
    "" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( -perm 777 -o -perm 444 \) -print" "${__test_actual}" 

  __UAC_TOOL_FIND_OPERATORS_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "777|444" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -perm 777 -o -perm 444 \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -perm 777 -print; find ${__TEST_TEMP_DIR}/mount-point -perm 444 -print; " "${__test_actual}"
  fi
  
  __UAC_TOOL_FIND_PERM_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "777|444" \
    "" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( -perm 777 -o -perm 444 \) -print" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -perm 777 -print; find ${__TEST_TEMP_DIR}/mount-point -perm 444 -print; " "${__test_actual}"
  fi
}

test_build_find_command_print0_success()
{
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "true" \
    "" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print0" "${__test_actual}"

  __UAC_TOOL_FIND_PRINT0_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "true" \
    "" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -print0" "${__test_actual}"
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi
  
}

test_build_find_command_mtime_success()
{
  __UAC_CONF_ENABLE_FIND_ATIME=false
  __UAC_CONF_ENABLE_FIND_CTIME=false

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -mtime -10 -print" "${__test_actual}" 
  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -mtime +20 -print" "${__test_actual}" 

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -mtime -10 -mtime +20 -print" "${__test_actual}" 

  __UAC_TOOL_FIND_MTIME_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -mtime -10 -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi
    

    __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -mtime +20 -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -mtime -10 -mtime +20 -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi
  
}

test_build_find_command_atime_success()
{
  __UAC_CONF_ENABLE_FIND_MTIME=false
  __UAC_CONF_ENABLE_FIND_CTIME=false

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -atime -10 -print" "${__test_actual}" 
  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -atime +20 -print" "${__test_actual}" 

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -atime -10 -atime +20 -print" "${__test_actual}" 

  __UAC_TOOL_FIND_ATIME_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -atime -10 -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi
    

    __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -atime +20 -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -atime -10 -atime +20 -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi
  
}

test_build_find_command_ctime_success()
{
  __UAC_CONF_ENABLE_FIND_MTIME=false
  __UAC_CONF_ENABLE_FIND_ATIME=false

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -ctime -10 -print" "${__test_actual}" 
  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -ctime +20 -print" "${__test_actual}" 

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point -ctime -10 -ctime +20 -print" "${__test_actual}" 

  __UAC_TOOL_FIND_CTIME_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -ctime -10 -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi
    

    __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -ctime +20 -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point -ctime -10 -ctime +20 -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -print" "${__test_actual}" 
  fi
  
}

test_build_find_command_mtime_ctime_success()
{
  __UAC_CONF_ENABLE_FIND_ATIME=false

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( \( -mtime -10 \) -o \( -ctime -10 \) \) -print" "${__test_actual}" 
  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( \( -mtime +20 \) -o \( -ctime +20 \) \) -print" "${__test_actual}" 

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( \( -mtime -10 -mtime +20 \) -o \( -ctime -10 -ctime +20 \) \) -print" "${__test_actual}" 

  __UAC_TOOL_FIND_CTIME_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( \( -mtime -10 \) -o \( -ctime -10 \) \) -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -mtime -10 -print" "${__test_actual}" 
  fi
    

    __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( \( -mtime +20 \) -o \( -ctime +20 \) \) -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -mtime +20 -print" "${__test_actual}" 
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( \( -mtime -10 -mtime +20 \) -o \( -ctime -10 -ctime +20 \) \) -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -mtime -10 -mtime +20 -print" "${__test_actual}" 
  fi
  
}

test_build_find_command_mtime_atime_success()
{
  __UAC_CONF_ENABLE_FIND_CTIME=false

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( \( -mtime -10 \) -o \( -atime -10 \) \) -print" "${__test_actual}" 
  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( \( -mtime +20 \) -o \( -atime +20 \) \) -print" "${__test_actual}" 

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( \( -mtime -10 -mtime +20 \) -o \( -atime -10 -atime +20 \) \) -print" "${__test_actual}" 

  __UAC_TOOL_FIND_ATIME_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( \( -mtime -10 \) -o \( -atime -10 \) \) -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -mtime -10 -print" "${__test_actual}" 
  fi

    __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( \( -mtime +20 \) -o \( -atime +20 \) \) -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -mtime +20 -print" "${__test_actual}" 
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( \( -mtime -10 -mtime +20 \) -o \( -atime -10 -atime +20 \) \) -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -mtime -10 -mtime +20 -print" "${__test_actual}" 
  fi
  
}

test_build_find_command_ctime_atime_success()
{
  __UAC_CONF_ENABLE_FIND_MTIME=false

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( \( -ctime -10 \) -o \( -atime -10 \) \) -print" "${__test_actual}" 
  
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( \( -ctime +20 \) -o \( -atime +20 \) \) -print" "${__test_actual}" 

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  assertEquals "find ${__TEST_TEMP_DIR}/mount-point \( \( -ctime -10 -ctime +20 \) -o \( -atime -10 -atime +20 \) \) -print" "${__test_actual}" 

  __UAC_TOOL_FIND_ATIME_SUPPORT=false
  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    ""`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( \( -ctime -10 \) -o \( -atime -10 \) \) -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -ctime -10 -print" "${__test_actual}" 
  fi

    __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( \( -ctime +20 \) -o \( -atime +20 \) \) -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -ctime +20 -print" "${__test_actual}" 
  fi

  __test_actual=`_build_find_command \
    "${__TEST_TEMP_DIR}/mount-point" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "" \
    "10" \
    "20"`

  if commandExists "perl"; then
    assertEquals "find_pl ${__TEST_TEMP_DIR}/mount-point \( \( -ctime -10 -ctime +20 \) -o \( -atime -10 -atime +20 \) \) -print" "${__test_actual}" 
  else
    assertEquals "find ${__TEST_TEMP_DIR}/mount-point -ctime -10 -ctime +20 -print" "${__test_actual}" 
  fi
  
}