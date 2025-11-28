#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/prepend_mount_point.sh"
  . "${UAC_DIR}/lib/sanitize_path.sh"
}

test_prepend_mount_point_success()
{
  __test_actual=`_prepend_mount_point "/" ""`
  assertEquals "/" "${__test_actual}"

  __test_actual=`_prepend_mount_point "/" "/"`
  assertEquals "/" "${__test_actual}"

  __test_actual=`_prepend_mount_point "///" "/"`
  assertEquals "/" "${__test_actual}"

  __test_actual=`_prepend_mount_point "/usr/" "/"`
  assertEquals "/usr" "${__test_actual}"

  __test_actual=`_prepend_mount_point "/usr/ /etc" "/"`
  assertEquals "/usr /etc" "${__test_actual}"

  __test_actual=`_prepend_mount_point "/" "/mnt/usb"`
  assertEquals "/\"mnt/usb\"" "${__test_actual}"

  __test_actual=`_prepend_mount_point "/ /home /\"Application Support\"/Google" "/mnt/usb"`
  assertEquals "/\"mnt/usb\" /\"mnt/usb\"/home /\"mnt/usb\"/\"Application Support\"/Google" "${__test_actual}"

  __test_actual=`_prepend_mount_point "/Library" "\"/mount point\""`
  assertEquals "/\"mount point\"/Library" "${__test_actual}"
}
