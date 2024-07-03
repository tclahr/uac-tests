#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/command_collector.sh"

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
  
  _log_msg()
  {
    __lm_level="${1:-INF}"
    __lm_message="${2:-}"

    printf %b "YYYYMMDD hh:mm:ss Z ${__lm_level} ${__lm_message}\n" \
      >>"${__TEST_TEMP_DIR}/test.log" \
      2>/dev/null
  }

  _run_command()
  {
    __rc_command=`printf %b "${1}" | awk 'BEGIN {ORS="/n"} {print $0}' | sed -e 's|  *| |g' -e 's|/n$||'`
    _log_msg CMD "${__rc_command}"
    eval "${1:-}" 2>/dev/null
  }

  _verbose_msg()
  {
    return 0
  }

  _sanitize_output_directory()
  {
    printf %b "${1:-}"
  }
  
  _sanitize_output_file()
  {
    printf %b "${1:-}"
  }

  __ps()
  {
    cat << EOF
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 07:54 ?        00:00:01 /sbin/init
root           2       0  0 07:54 ?        00:00:00 [kthreadd]
root           3       2  0 07:54 ?        00:00:00 [rcu_gp]
EOF
  }

  __lsof()
  {
    cat << EOF
lsof      123687                  uac  mem       REG               0,29           1120470 /usr/lib/libkrb5support.so.0.1 (path dev=0,31)
lsof      123687                  uac  mem       REG               0,29              7884 /usr/lib/libcom_err.so.2.1 (path dev=0,31)
lsof      123687                  uac  mem       REG               0,29           1120447 /usr/lib/libk5crypto.so.3.1 (path dev=0,31)
EOF
  }

  __virsh_list()
  {
    cat << EOF
vm-01
vm-02
vm-03
EOF
  }

  __virsh_nodeinfo()
  {
    printf %b "nodeinfo: ${1:-}"
  }

  __unknown_command()
  {
    printf %b "unknown command error\nplease try again later\n" >&2
  }

  __unknown_foreach_command()
  {
    printf %b "unknown command error\nplease try again later\n" >&2
  }

  __avml()
  {
    printf %b "avml" >>"${1:-/dev/null}"
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_command_collector"

  mkdir -p "${__TEST_TEMP_DIR}"

  __UAC_VERBOSE_CMD_PREFIX=" > "

}

test_command_collector_single_command_success()
{
  _command_collector \
    "" \
    "__ps" \
    "${__TEST_TEMP_DIR}/single_command_success" \
    "ps.txt"

  __test_container=`cat "${__TEST_TEMP_DIR}/single_command_success/ps.txt"`
  assertContains "${__test_container}" "kthreadd"
}

test_command_collector_multiple_command_success()
{
  _command_collector \
    "" \
    "__ps
__lsof
__virsh_list" \
    "${__TEST_TEMP_DIR}/multiple_command_success" \
    "multiple_command.txt"

  __test_container=`cat "${__TEST_TEMP_DIR}/multiple_command_success/multiple_command.txt"`
  assertContains "${__test_container}" "kthreadd"
  assertContains "${__test_container}" "libkrb5support"
  assertContains "${__test_container}" "vm-02"
}

test_command_collector_command_compress_output_file_success()
{
  _command_collector \
    "" \
    "__ps" \
    "${__TEST_TEMP_DIR}/command_compress_output_file_success" \
    "ps.txt" \
    true

  if commandExists "gzip"; then
    assertFileExists "${__TEST_TEMP_DIR}/command_compress_output_file_success/ps.txt.gz"
  else
    assertFileExists "${__TEST_TEMP_DIR}/command_compress_output_file_success/ps.txt"
  fi
}

test_command_collector_command_unknown_command_success()
{
  _command_collector \
    "" \
    "__unknown_command" \
    "${__TEST_TEMP_DIR}/command_unknown_command_success" \
    "ps.txt"

  assertFileNotExists "${__TEST_TEMP_DIR}/command_unknown_command_success/ps.txt"
}

test_command_collector_command_empty_output_file_success()
{
  _command_collector \
    "" \
    "__avml avml.raw" \
    "${__TEST_TEMP_DIR}/command_empty_output_file_success" \
    ""

  assertFileExists "${__TEST_TEMP_DIR}/command_empty_output_file_success/avml.raw"
  __test_actual=`cat "${__TEST_TEMP_DIR}/command_empty_output_file_success/avml.raw"`
  assertEquals "avml" "${__test_actual}"
}

test_command_collector_command_empty_compress_output_file_success()
{
  _command_collector \
    "" \
    "cat /tmp/unknown-file-1HrcH9TnsS_2" \
    "${__TEST_TEMP_DIR}/command_empty_compress_output_file_success" \
    "empty_file.txt" \
    true

  if commandExists "gzip"; then
    assertFileNotExists "${__TEST_TEMP_DIR}/command_empty_compress_output_file_success/empty_file.txt.gz"
  else
    assertFileNotExists "${__TEST_TEMP_DIR}/command_empty_compress_output_file_success/empty_file.txt"
  fi
}

test_command_collector_foreach_command_success()
{
  _command_collector \
    "__virsh_list" \
    "__virsh_nodeinfo %line%" \
    "${__TEST_TEMP_DIR}/foreach_command_success" \
    "%line%.txt"

  __test_actual=`cat "${__TEST_TEMP_DIR}/foreach_command_success/vm-01.txt"`
  assertEquals "nodeinfo: vm-01"  "${__test_actual}"
}

test_command_collector_foreach_command_compress_output_file_success()
{
  _command_collector \
    "__virsh_list" \
    "__virsh_nodeinfo %line%" \
    "${__TEST_TEMP_DIR}/foreach_command_compress_output_file_success" \
    "%line%.txt" \
    true

  if commandExists "gzip"; then
    assertFileExists "${__TEST_TEMP_DIR}/foreach_command_compress_output_file_success/vm-01.txt.gz"
  else
    assertFileExists "${__TEST_TEMP_DIR}/foreach_command_compress_output_file_success/vm-01.txt"
  fi
  
}

test_command_collector_foreach_command_empty_compress_output_file_success()
{
  _command_collector \
    "__virsh_list" \
    "cat /tmp/unknown-file-1HrcH9TnsS_2" \
    "${__TEST_TEMP_DIR}/foreach_command_empty_compress_output_file_success" \
    "%line%.txt" \
    true

  if commandExists "gzip"; then
    assertFileNotExists "${__TEST_TEMP_DIR}/foreach_command_empty_compress_output_file_success/vm-01.txt.gz"
  else
    assertFileNotExists "${__TEST_TEMP_DIR}/foreach_command_empty_compress_output_file_success/vm-01.txt"
  fi
  
}

test_command_collector_foreach_command_unknown_command_success()
{
  _command_collector \
    "__unknown_foreach_command" \
    "__virsh_nodeinfo %line%" \
    "${__TEST_TEMP_DIR}/foreach_command_unknown_command_success" \
    "%line%.txt"

  assertFileNotExists "${__TEST_TEMP_DIR}/foreach_command_unknown_command_success/vm-01.txt.gz"

  _command_collector \
    "__virsh_list" \
    "__unknown_command %line%" \
    "${__TEST_TEMP_DIR}/foreach_command_unknown_command_success" \
    "%line%.txt"

  assertFileNotExists "${__TEST_TEMP_DIR}/foreach_command_unknown_command_success/vm-01.txt.gz"
}

test_command_collector_empty_command_fail()
{
  assertFalse "_command_collector \"\" \"\" \"${__TEST_TEMP_DIR}/empty_command_fail\" \"ps.txt\" false \"${__TEST_TEMP_DIR}\""
}

test_command_collector_empty_output_directory_fail()
{
  assertFalse "_command_collector \"\" \"__ps\" \"\" \"ps.txt\" false \"${__TEST_TEMP_DIR}\""
}
