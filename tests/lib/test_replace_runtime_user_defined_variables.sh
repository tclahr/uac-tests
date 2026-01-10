#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/replace_runtime_user_defined_variables.sh"
}

test_replace_runtime_user_defined_variables_simple_replacement_success()
{
  __UAC_USER_DEFINED_VAR_NAME="UAC"
  __test_string="Hello %NAME%!"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "Hello UAC!" "${__test_actual}"
}

test_replace_runtime_user_defined_variables_with_default_when_unset_success()
{
  unset __UAC_USER_DEFINED_VAR_env
  __test_string="Environment: %env=prod%"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "Environment: prod" "${__test_actual}"
}

test_replace_runtime_user_defined_variables_default_not_used_when_set_success()
{
  __UAC_USER_DEFINED_VAR_env="dev"
  __test_string="Environment: %env=prod%"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "Environment: dev" "${__test_actual}"
}

test_replace_runtime_user_defined_variables_empty_when_unset_and_no_default_success()
{
  unset __UAC_USER_DEFINED_VAR_region
  __test_string="Region=%region%"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "Region=" "${__test_actual}"
}

test_replace_multiple_user_defined_variables_success()
{
  __UAC_USER_DEFINED_VAR_ONE="1"
  __UAC_USER_DEFINED_VAR_TWO="2"
  __test_string="%ONE% + %TWO% = 3"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "1 + 2 = 3" "${__test_actual}"

  __test_string="%ONE% + %TWO% + %THREE=3% = 6"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "1 + 2 + 3 = 6" "${__test_actual}"
}

test_replace_runtime_user_defined_variables_with_special_characters_success()
{
  __UAC_USER_DEFINED_VAR_special_char="ls \&\& cd /tmp \|\| echo abc! \&\& ls *"
  __test_string="PATH=%special_char%"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "PATH=ls && cd /tmp || echo abc! && ls *" "${__test_actual}"

  __UAC_USER_DEFINED_VAR_number="32"
  __test_string="ls && avml %number% -o output || echo abc!"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "ls && avml 32 -o output || echo abc!" "${__test_actual}"
}

test_replace_runtime_user_defined_variables_preserve_literal_percentage_signs_success()
{
  __test_string="100% complete"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "100% complete" "${__test_actual}"
}

test_replace_runtime_user_defined_variables_mixed_literal_and_variable_percentage_signs_success()
{
  __UAC_USER_DEFINED_VAR_value="42"
  __test_string="Result: %value% (100%)"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "Result: 42 (100%)" "${__test_actual}"
}

test_replace_runtime_user_defined_variables_skip_runtime_variables_success()
{
  __UAC_HOSTNAME="testhost"
  __UAC_MOUNT_POINT="/mount-point"
  __test_string="path: %hostname% /%user% /%user_home% /%mount_point%"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "path: testhost /%user% /%user_home% //mount-point" "${__test_actual}"

  __UAC_START_DATE=""
  __UAC_START_DATE_EPOCH=""
  __UAC_END_DATE=""
  __UAC_END_DATE_EPOCH=""
  __test_string="path: %start_date% %start_date_epoch% %end_date% %end_date_epoch%"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "path: 1970-01-01 1 2031-12-31 1956527999" "${__test_actual}"

  __UAC_START_DATE="2020-02-02"
  __UAC_START_DATE_EPOCH="1580601600"
  __UAC_END_DATE=""
  __UAC_END_DATE_EPOCH=""
  __test_string="path: %start_date% %start_date_epoch% %end_date% %end_date_epoch%"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "path: 2020-02-02 1580601600 2031-12-31 1956527999" "${__test_actual}"

}

test_replace_runtime_user_defined_variables_non_local_mount_points_success()
{
  __UAC_EXCLUDE_MOUNT_POINTS="/proc|/sys"
  __test_string="path: %non_local_mount_points%"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "path: /proc|/sys" "${__test_actual}"

  __test_string="path: %non_local_mount_points% %non_local_mount_points%"
  __test_actual=`_replace_runtime_user_defined_variables "${__test_string}"`
  assertEquals "path: /proc|/sys /proc|/sys" "${__test_actual}"
}