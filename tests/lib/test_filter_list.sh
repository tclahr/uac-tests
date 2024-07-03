#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/filter_list.sh"
}

test_filter_list_success()
{
  __test_list="/etc/passwd
/etc/shadow
/tmp/file01.txt
/tmp/file02.txt
/home/user/.bash_history
/home/user/.sh_history"
  __test_exclude_list="/etc/passwd
/tmp/file01.txt
/home/user/.sh_history"
  __test_actual=`_filter_list "${__test_list}" "${__test_exclude_list}"`
  assertEquals "/etc/shadow
/tmp/file02.txt
/home/user/.bash_history" "${__test_actual}"
}

test_filter_list_empty_list_success()
{
  __test_list=""
  __test_exclude_list="/etc/passwd
/tmp/file01.txt
/home/user/.sh_history"
  __test_actual=`_filter_list "${__test_list}" "${__test_exclude_list}"`
  assertNull "${__test_actual}"
}

test_filter_list_empty_exclude_list_success()
{
  __test_list="/etc/passwd
/etc/shadow
/tmp/file01.txt
/tmp/file02.txt
/home/user/.bash_history
/home/user/.sh_history"
  __test_exclude_list=""
  __test_actual=`_filter_list "${__test_list}" "${__test_exclude_list}"`
  assertEquals "/etc/passwd
/etc/shadow
/tmp/file01.txt
/tmp/file02.txt
/home/user/.bash_history
/home/user/.sh_history" "${__test_actual}"
}

test_filter_list_empty_both_lists_success()
{
  __test_list=""
  __test_exclude_list=""
  __test_actual=`_filter_list "${__test_list}" "${__test_exclude_list}"`
  assertNull "${__test_actual}"
}

test_filter_list_empty_line_success()
{
  __test_list="/etc/passwd
/etc/shadow


/tmp/file01.txt
/tmp/file02.txt
/home/user/.bash_history
/home/user/.sh_history"
  __test_exclude_list="/etc/passwd
/tmp/file01.txt


/home/user/.sh_history"
  __test_actual=`_filter_list "${__test_list}" "${__test_exclude_list}"`
  assertEquals "/etc/shadow
/tmp/file02.txt
/home/user/.bash_history" "${__test_actual}"
}