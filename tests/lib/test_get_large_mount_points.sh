#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2034,SC2329

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_large_mount_points.sh"
}

# always excludes root file system even when it exceeds the size threshold
test_get_large_mount_points_always_excludes_root_mount_point()
{
  _get_mount_point_used_size()
  {
    printf "%s\n" "/|9999999"
    printf "%s\n" "/home|1048576"
  }

  __test_actual=`_get_large_mount_points "linux" 0`
  assertNotContains "regex" true "${__test_actual}" "^/$"
  assertContains "${__test_actual}" "/home"
}

# returns mount points whose used size is strictly greater than the given size
test_get_large_mount_points_returns_mount_points_above_size_threshold()
{
  _get_mount_point_used_size()
  {
    printf "%s\n" "/|9999999"
    printf "%s\n" "/home|2097152"
    printf "%s\n" "/var|524288"
    printf "%s\n" "/tmp|131072"
  }

  __test_actual=`_get_large_mount_points "linux" 1000000`
  assertContains "${__test_actual}" "/home"
  assertNotContains "${__test_actual}" "/var"
  assertNotContains "${__test_actual}" "/tmp"
}

# excludes mount points whose used size equals the size threshold (not strictly greater)
test_get_large_mount_points_excludes_mount_point_equal_to_size_threshold()
{
  _get_mount_point_used_size()
  {
    printf "%s\n" "/|9999999"
    printf "%s\n" "/home|1048576"
  }

  __test_actual=`_get_large_mount_points "linux" 1048576`
  assertNull "${__test_actual}"
}

# returns empty when all non-root mount points are at or below the size threshold
test_get_large_mount_points_returns_empty_when_no_mount_points_exceed_size()
{
  _get_mount_point_used_size()
  {
    printf "%s\n" "/|9999999"
    printf "%s\n" "/home|512"
    printf "%s\n" "/var|256"
  }

  __test_actual=`_get_large_mount_points "linux" 1048576`
  assertNull "${__test_actual}"
}

# returns empty when _get_mount_point_used_size produces no output
test_get_large_mount_points_returns_empty_when_no_mount_points()
{
  _get_mount_point_used_size()
  {
    :
  }

  __test_actual=`_get_large_mount_points "linux" 0`
  assertNull "${__test_actual}"
}

# returns multiple mount points pipe-separated when several exceed the threshold
test_get_large_mount_points_returns_pipe_separated_list_for_multiple_matches()
{
  _get_mount_point_used_size()
  {
    printf "%s\n" "/|9999999"
    printf "%s\n" "/home|2097152"
    printf "%s\n" "/var|1048577"
    printf "%s\n" "/tmp|100"
  }

  __test_actual=`_get_large_mount_points "linux" 1048576`
  assertContains "${__test_actual}" "/home"
  assertContains "${__test_actual}" "/var"
  assertContains "regex" true "${__test_actual}" "^/home\|/var$"
}

# uses default size of 0 when size argument is omitted, returning all non-root mount points
test_get_large_mount_points_uses_default_size_zero_when_size_omitted()
{
  _get_mount_point_used_size()
  {
    printf "%s\n" "/|9999999"
    printf "%s\n" "/home|1"
  }

  __test_actual=`_get_large_mount_points "linux"`
  assertContains "${__test_actual}" "/home"
  assertNotContains "regex" true "${__test_actual}" "^/$"
}

# returns empty when only root mount point is present and exceeds threshold
test_get_large_mount_points_returns_empty_when_only_root_exceeds_threshold()
{
  _get_mount_point_used_size()
  {
    printf "%s\n" "/|9999999"
  }

  __test_actual=`_get_large_mount_points "linux" 0`
  assertNull "${__test_actual}"
}

# output contains no pipe separator when only one mount point matches
test_get_large_mount_points_no_leading_or_trailing_pipe_for_single_match()
{
  _get_mount_point_used_size()
  {
    printf "%s\n" "/|9999999"
    printf "%s\n" "/data|5000000"
  }

  __test_actual=`_get_large_mount_points "linux" 0`
  assertNotContains "regex" true "${__test_actual}" "^\|"
  assertNotContains "regex" true "${__test_actual}" "\|$"
  assertEquals "/data" "${__test_actual}"
}