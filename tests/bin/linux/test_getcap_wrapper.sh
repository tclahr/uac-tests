#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_getcap_wrapper"

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

test_getcap_wrapper_empty_exclude_paths_success()
{
  __test_container=`"${UAC_DIR}"/bin/linux/getcap_wrapper.sh "${__UAC_MOUNT_POINT}"`
  assertEquals "getcap \"${__UAC_MOUNT_POINT}\"/*
getcap -r \"${__UAC_MOUNT_POINT}/bin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/boot\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dev\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dir with spaces\"/*
getcap -r \"${__UAC_MOUNT_POINT}/etc\"/*
getcap -r \"${__UAC_MOUNT_POINT}/home\"/*
getcap -r \"${__UAC_MOUNT_POINT}/lib\"/*
getcap -r \"${__UAC_MOUNT_POINT}/media\"/*
getcap -r \"${__UAC_MOUNT_POINT}/mnt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/opt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/proc\"/*
getcap -r \"${__UAC_MOUNT_POINT}/run\"/*
getcap -r \"${__UAC_MOUNT_POINT}/srv\"/*
getcap -r \"${__UAC_MOUNT_POINT}/sys\"/*
getcap -r \"${__UAC_MOUNT_POINT}/tmp\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr\"/*
getcap -r \"${__UAC_MOUNT_POINT}/var\"/*" "${__test_container}"
}

test_getcap_wrapper_exclude_paths_success()
{
  __test_container=`"${UAC_DIR}"/bin/linux/getcap_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc"`
  assertEquals "getcap \"${__UAC_MOUNT_POINT}\"/*
getcap -r \"${__UAC_MOUNT_POINT}/bin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/boot\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dev\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dir with spaces\"/*
getcap -r \"${__UAC_MOUNT_POINT}/etc\"/*
getcap -r \"${__UAC_MOUNT_POINT}/home\"/*
getcap -r \"${__UAC_MOUNT_POINT}/lib\"/*
getcap -r \"${__UAC_MOUNT_POINT}/media\"/*
getcap -r \"${__UAC_MOUNT_POINT}/mnt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/opt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/run\"/*
getcap -r \"${__UAC_MOUNT_POINT}/srv\"/*
getcap -r \"${__UAC_MOUNT_POINT}/sys\"/*
getcap -r \"${__UAC_MOUNT_POINT}/tmp\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr\"/*
getcap -r \"${__UAC_MOUNT_POINT}/var\"/*" "${__test_container}"

  __test_container=`"${UAC_DIR}"/bin/linux/getcap_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr"`
  assertEquals "getcap \"${__UAC_MOUNT_POINT}\"/*
getcap -r \"${__UAC_MOUNT_POINT}/bin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/boot\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dev\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dir with spaces\"/*
getcap -r \"${__UAC_MOUNT_POINT}/etc\"/*
getcap -r \"${__UAC_MOUNT_POINT}/home\"/*
getcap -r \"${__UAC_MOUNT_POINT}/lib\"/*
getcap -r \"${__UAC_MOUNT_POINT}/media\"/*
getcap -r \"${__UAC_MOUNT_POINT}/mnt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/opt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/run\"/*
getcap -r \"${__UAC_MOUNT_POINT}/srv\"/*
getcap -r \"${__UAC_MOUNT_POINT}/sys\"/*
getcap -r \"${__UAC_MOUNT_POINT}/tmp\"/*
getcap -r \"${__UAC_MOUNT_POINT}/var\"/*" "${__test_container}"

__test_container=`"${UAC_DIR}"/bin/linux/getcap_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/dir with spaces"`
  assertEquals "getcap \"${__UAC_MOUNT_POINT}\"/*
getcap -r \"${__UAC_MOUNT_POINT}/bin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/boot\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dev\"/*
getcap -r \"${__UAC_MOUNT_POINT}/etc\"/*
getcap -r \"${__UAC_MOUNT_POINT}/home\"/*
getcap -r \"${__UAC_MOUNT_POINT}/lib\"/*
getcap -r \"${__UAC_MOUNT_POINT}/media\"/*
getcap -r \"${__UAC_MOUNT_POINT}/mnt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/opt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/run\"/*
getcap -r \"${__UAC_MOUNT_POINT}/srv\"/*
getcap -r \"${__UAC_MOUNT_POINT}/sys\"/*
getcap -r \"${__UAC_MOUNT_POINT}/tmp\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr\"/*
getcap -r \"${__UAC_MOUNT_POINT}/var\"/*" "${__test_container}"

  __test_container=`"${UAC_DIR}"/bin/linux/getcap_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib"`
  assertEquals "getcap \"${__UAC_MOUNT_POINT}\"/*
getcap -r \"${__UAC_MOUNT_POINT}/bin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/boot\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dev\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dir with spaces\"/*
getcap -r \"${__UAC_MOUNT_POINT}/etc\"/*
getcap -r \"${__UAC_MOUNT_POINT}/home\"/*
getcap -r \"${__UAC_MOUNT_POINT}/lib\"/*
getcap -r \"${__UAC_MOUNT_POINT}/media\"/*
getcap -r \"${__UAC_MOUNT_POINT}/mnt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/opt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/run\"/*
getcap -r \"${__UAC_MOUNT_POINT}/srv\"/*
getcap -r \"${__UAC_MOUNT_POINT}/sys\"/*
getcap -r \"${__UAC_MOUNT_POINT}/tmp\"/*
getcap \"${__UAC_MOUNT_POINT}/usr\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/bin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/include\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/lib64\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/local\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/sbin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/var\"/*" "${__test_container}"

  __test_container=`"${UAC_DIR}"/bin/linux/getcap_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib/modules|${__UAC_MOUNT_POINT}/usr/local/bin"`
  assertEquals "getcap \"${__UAC_MOUNT_POINT}\"/*
getcap -r \"${__UAC_MOUNT_POINT}/bin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/boot\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dev\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dir with spaces\"/*
getcap -r \"${__UAC_MOUNT_POINT}/etc\"/*
getcap -r \"${__UAC_MOUNT_POINT}/home\"/*
getcap -r \"${__UAC_MOUNT_POINT}/lib\"/*
getcap -r \"${__UAC_MOUNT_POINT}/media\"/*
getcap -r \"${__UAC_MOUNT_POINT}/mnt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/opt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/run\"/*
getcap -r \"${__UAC_MOUNT_POINT}/srv\"/*
getcap -r \"${__UAC_MOUNT_POINT}/sys\"/*
getcap -r \"${__UAC_MOUNT_POINT}/tmp\"/*
getcap \"${__UAC_MOUNT_POINT}/usr\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/bin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/include\"/*
getcap \"${__UAC_MOUNT_POINT}/usr/lib\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/lib/systemd\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/lib64\"/*
getcap \"${__UAC_MOUNT_POINT}/usr/local\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/local/include\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/local/lib\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/local/share\"/*
getcap -r \"${__UAC_MOUNT_POINT}/usr/sbin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/var\"/*" "${__test_container}"

__test_container=`"${UAC_DIR}"/bin/linux/getcap_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib/modules|${__UAC_MOUNT_POINT}/usr/local/bin|${__UAC_MOUNT_POINT}/usr"`
  assertEquals "getcap \"${__UAC_MOUNT_POINT}\"/*
getcap -r \"${__UAC_MOUNT_POINT}/bin\"/*
getcap -r \"${__UAC_MOUNT_POINT}/boot\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dev\"/*
getcap -r \"${__UAC_MOUNT_POINT}/dir with spaces\"/*
getcap -r \"${__UAC_MOUNT_POINT}/etc\"/*
getcap -r \"${__UAC_MOUNT_POINT}/home\"/*
getcap -r \"${__UAC_MOUNT_POINT}/lib\"/*
getcap -r \"${__UAC_MOUNT_POINT}/media\"/*
getcap -r \"${__UAC_MOUNT_POINT}/mnt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/opt\"/*
getcap -r \"${__UAC_MOUNT_POINT}/run\"/*
getcap -r \"${__UAC_MOUNT_POINT}/srv\"/*
getcap -r \"${__UAC_MOUNT_POINT}/sys\"/*
getcap -r \"${__UAC_MOUNT_POINT}/tmp\"/*
getcap -r \"${__UAC_MOUNT_POINT}/var\"/*" "${__test_container}"

}