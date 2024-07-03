#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/is_in_list.sh"
}

test_is_in_list_first_element_success()
{
  __test_element="banana"
  __test_list="banana|apple|pineapple"
  assertTrue "_is_in_list \"${__test_element}\" \"${__test_list}\""
}

test_is_in_list_middle_element_success()
{
  __test_element="apple"
  __test_list=" banana|apple|orange|pineapple"
  assertTrue "_is_in_list \"${__test_element}\" \"${__test_list}\""
}

test_is_in_list_last_element_success()
{
  __test_element="pineapple"
  __test_list=" banana|apple|pineapple"
  assertTrue "_is_in_list \"${__test_element}\" \"${__test_list}\""
}

test_is_in_list_element_not_in_list_success()
{
  __test_element="pear"
  __test_list="banana,apple,pineapple"
  assertFalse "_is_in_list \"${__test_element}\" \"${__test_list}\""
}

test_is_in_list_empty_element_fail()
{
  __test_element=""
  __test_list="banana,apple,pineapple"
  assertFalse "_is_in_list \"${__test_element}\" \"${__test_list}\""
}

test_is_in_list_empty_list_fail()
{
  __test_element="apple"
  __test_list=""
  assertFalse "_is_in_list \"${__test_element}\" \"${__test_list}\""
}

test_is_in_list_empty_element_and_list_fail()
{
  __test_element=""
  __test_list=""
  assertFalse "_is_in_list \"${__test_element}\" \"${__test_list}\"" 
}