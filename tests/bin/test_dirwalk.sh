#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{

  PATH="${UAC_DIR}/bin:${PATH}"

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_dirwalk"

  # Create top-level directories
  for d in bin boot dev etc home var usr tmp lib proc sys run mnt opt media srv; do
    mkdir -p "${__TEST_TEMP_DIR}/mount-point/$d"
  done

  # create directory with spaces
  mkdir -p "${__TEST_TEMP_DIR}/mount-point/dir with spaces"

  # Create home user directories
  for d in home/user1 home/user2; do
    mkdir -p "${__TEST_TEMP_DIR}/mount-point/$d"
  done

  # Create mount and media points
  for d in mnt/nfs mnt/usb media/cdrom media/external opt/myapp srv/www; do
    mkdir -p "${__TEST_TEMP_DIR}/mount-point/$d"
  done

  # Create /usr subdirectories
  for d in usr/bin usr/sbin usr/lib/systemd usr/lib/modules usr/include/linux usr/include/sys usr/include/net usr/lib64 usr/local/bin usr/local/lib usr/local/include usr/local/share; do
    mkdir -p "${__TEST_TEMP_DIR}/mount-point/$d"
  done

  # Create home user subdirectories
  for d in home/user1/projects home/user1/docs home/user2/private home/user2/downloads; do
    mkdir -p "${__TEST_TEMP_DIR}/mount-point/$d"
  done

  # Create some dummy files to simulate system files
  touch "${__TEST_TEMP_DIR}/mount-point/proc/uptime"
  touch "${__TEST_TEMP_DIR}/mount-point/sys/kernel"
  touch "${__TEST_TEMP_DIR}/mount-point/usr/bin/bash"
  touch "${__TEST_TEMP_DIR}/mount-point/usr/bin/ls"
  touch "${__TEST_TEMP_DIR}/mount-point/usr/lib/systemd/systemd"
  touch "${__TEST_TEMP_DIR}/mount-point/usr/include/stdio.h"
  touch "${__TEST_TEMP_DIR}/mount-point/usr/include/linux/version.h"
  touch "${__TEST_TEMP_DIR}/mount-point/opt/myapp/app.sh"

  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"
  __UAC_MOUNT_POINT="${__TEST_TEMP_DIR}/mount-point"

}

test_dirwalk_invalid_mode_fail()
{
  assertFail "dirwalk invalid_mode /"
}

test_dirwalk_parents_empty_exclude_paths_success()
{
  __test_container=`dirwalk parents "${__UAC_MOUNT_POINT}"`
  assertEquals "${__UAC_MOUNT_POINT}" "${__test_container}"
}

test_dirwalk_children_empty_exclude_paths_success()
{
  __test_container=`dirwalk children "${__UAC_MOUNT_POINT}"`
  assertEquals "${__UAC_MOUNT_POINT}/bin
${__UAC_MOUNT_POINT}/boot
${__UAC_MOUNT_POINT}/dev
${__UAC_MOUNT_POINT}/dir with spaces
${__UAC_MOUNT_POINT}/etc
${__UAC_MOUNT_POINT}/home
${__UAC_MOUNT_POINT}/lib
${__UAC_MOUNT_POINT}/media
${__UAC_MOUNT_POINT}/mnt
${__UAC_MOUNT_POINT}/opt
${__UAC_MOUNT_POINT}/proc
${__UAC_MOUNT_POINT}/run
${__UAC_MOUNT_POINT}/srv
${__UAC_MOUNT_POINT}/sys
${__UAC_MOUNT_POINT}/tmp
${__UAC_MOUNT_POINT}/usr
${__UAC_MOUNT_POINT}/var" "${__test_container}"
}

test_dirwalk_parents_exclude_paths_success()
{
  __test_container=`dirwalk parents "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc"`
  assertEquals "${__UAC_MOUNT_POINT}" "${__test_container}"

  __test_container=`dirwalk parents "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr"`
  assertEquals "${__UAC_MOUNT_POINT}" "${__test_container}"

  __test_container=`dirwalk parents "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr|${__UAC_MOUNT_POINT}/dir with spaces"`
  assertEquals "${__UAC_MOUNT_POINT}" "${__test_container}"

  __test_container=`dirwalk parents "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib"`
  assertEquals "${__UAC_MOUNT_POINT}
${__UAC_MOUNT_POINT}/usr" "${__test_container}"

  __test_container=`dirwalk parents "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib/modules|${__UAC_MOUNT_POINT}/usr/local/bin"`
  assertEquals "${__UAC_MOUNT_POINT}
${__UAC_MOUNT_POINT}/usr
${__UAC_MOUNT_POINT}/usr/lib
${__UAC_MOUNT_POINT}/usr/local" "${__test_container}"

  __test_container=`dirwalk parents "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib/modules|${__UAC_MOUNT_POINT}/usr/local/bin|${__UAC_MOUNT_POINT}/usr"`
  assertEquals "${__UAC_MOUNT_POINT}" "${__test_container}"
}

test_dirwalk_children_exclude_paths_success()
{
  __test_container=`dirwalk children "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc"`
  assertEquals "${__UAC_MOUNT_POINT}/bin
${__UAC_MOUNT_POINT}/boot
${__UAC_MOUNT_POINT}/dev
${__UAC_MOUNT_POINT}/dir with spaces
${__UAC_MOUNT_POINT}/etc
${__UAC_MOUNT_POINT}/home
${__UAC_MOUNT_POINT}/lib
${__UAC_MOUNT_POINT}/media
${__UAC_MOUNT_POINT}/mnt
${__UAC_MOUNT_POINT}/opt
${__UAC_MOUNT_POINT}/run
${__UAC_MOUNT_POINT}/srv
${__UAC_MOUNT_POINT}/sys
${__UAC_MOUNT_POINT}/tmp
${__UAC_MOUNT_POINT}/usr
${__UAC_MOUNT_POINT}/var" "${__test_container}"

  __test_container=`dirwalk children "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr"`
  assertEquals "${__UAC_MOUNT_POINT}/bin
${__UAC_MOUNT_POINT}/boot
${__UAC_MOUNT_POINT}/dev
${__UAC_MOUNT_POINT}/dir with spaces
${__UAC_MOUNT_POINT}/etc
${__UAC_MOUNT_POINT}/home
${__UAC_MOUNT_POINT}/lib
${__UAC_MOUNT_POINT}/media
${__UAC_MOUNT_POINT}/mnt
${__UAC_MOUNT_POINT}/opt
${__UAC_MOUNT_POINT}/run
${__UAC_MOUNT_POINT}/srv
${__UAC_MOUNT_POINT}/sys
${__UAC_MOUNT_POINT}/tmp
${__UAC_MOUNT_POINT}/var" "${__test_container}"

  __test_container=`dirwalk children "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr|${__UAC_MOUNT_POINT}/dir with spaces"`
  assertEquals "${__UAC_MOUNT_POINT}/bin
${__UAC_MOUNT_POINT}/boot
${__UAC_MOUNT_POINT}/dev
${__UAC_MOUNT_POINT}/etc
${__UAC_MOUNT_POINT}/home
${__UAC_MOUNT_POINT}/lib
${__UAC_MOUNT_POINT}/media
${__UAC_MOUNT_POINT}/mnt
${__UAC_MOUNT_POINT}/opt
${__UAC_MOUNT_POINT}/run
${__UAC_MOUNT_POINT}/srv
${__UAC_MOUNT_POINT}/sys
${__UAC_MOUNT_POINT}/tmp
${__UAC_MOUNT_POINT}/var" "${__test_container}"

  __test_container=`dirwalk children "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib"`
  assertEquals "${__UAC_MOUNT_POINT}/bin
${__UAC_MOUNT_POINT}/boot
${__UAC_MOUNT_POINT}/dev
${__UAC_MOUNT_POINT}/dir with spaces
${__UAC_MOUNT_POINT}/etc
${__UAC_MOUNT_POINT}/home
${__UAC_MOUNT_POINT}/lib
${__UAC_MOUNT_POINT}/media
${__UAC_MOUNT_POINT}/mnt
${__UAC_MOUNT_POINT}/opt
${__UAC_MOUNT_POINT}/run
${__UAC_MOUNT_POINT}/srv
${__UAC_MOUNT_POINT}/sys
${__UAC_MOUNT_POINT}/tmp
${__UAC_MOUNT_POINT}/usr/bin
${__UAC_MOUNT_POINT}/usr/include
${__UAC_MOUNT_POINT}/usr/lib64
${__UAC_MOUNT_POINT}/usr/local
${__UAC_MOUNT_POINT}/usr/sbin
${__UAC_MOUNT_POINT}/var" "${__test_container}"

  __test_container=`dirwalk children "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib/modules|${__UAC_MOUNT_POINT}/usr/local/bin"`
  assertEquals "${__UAC_MOUNT_POINT}/bin
${__UAC_MOUNT_POINT}/boot
${__UAC_MOUNT_POINT}/dev
${__UAC_MOUNT_POINT}/dir with spaces
${__UAC_MOUNT_POINT}/etc
${__UAC_MOUNT_POINT}/home
${__UAC_MOUNT_POINT}/lib
${__UAC_MOUNT_POINT}/media
${__UAC_MOUNT_POINT}/mnt
${__UAC_MOUNT_POINT}/opt
${__UAC_MOUNT_POINT}/run
${__UAC_MOUNT_POINT}/srv
${__UAC_MOUNT_POINT}/sys
${__UAC_MOUNT_POINT}/tmp
${__UAC_MOUNT_POINT}/usr/bin
${__UAC_MOUNT_POINT}/usr/include
${__UAC_MOUNT_POINT}/usr/lib/systemd
${__UAC_MOUNT_POINT}/usr/lib64
${__UAC_MOUNT_POINT}/usr/local/include
${__UAC_MOUNT_POINT}/usr/local/lib
${__UAC_MOUNT_POINT}/usr/local/share
${__UAC_MOUNT_POINT}/usr/sbin
${__UAC_MOUNT_POINT}/var" "${__test_container}"

  __test_container=`dirwalk children "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib/modules|${__UAC_MOUNT_POINT}/usr/local/bin|${__UAC_MOUNT_POINT}/usr"`
  assertEquals "${__UAC_MOUNT_POINT}/bin
${__UAC_MOUNT_POINT}/boot
${__UAC_MOUNT_POINT}/dev
${__UAC_MOUNT_POINT}/dir with spaces
${__UAC_MOUNT_POINT}/etc
${__UAC_MOUNT_POINT}/home
${__UAC_MOUNT_POINT}/lib
${__UAC_MOUNT_POINT}/media
${__UAC_MOUNT_POINT}/mnt
${__UAC_MOUNT_POINT}/opt
${__UAC_MOUNT_POINT}/run
${__UAC_MOUNT_POINT}/srv
${__UAC_MOUNT_POINT}/sys
${__UAC_MOUNT_POINT}/tmp
${__UAC_MOUNT_POINT}/var" "${__test_container}"

}

