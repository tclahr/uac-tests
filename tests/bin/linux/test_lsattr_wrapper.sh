#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006

oneTimeSetUp()
{

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_lsattr_wrapper"

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

test_lsattr_wrapper_empty_exclude_paths_success()
{
  __test_container=`"${UAC_DIR}"/bin/linux/lsattr_wrapper.sh "${__UAC_MOUNT_POINT}"`
  assertEquals "lsattr \"${__UAC_MOUNT_POINT}\"
lsattr -R \"${__UAC_MOUNT_POINT}/bin\"
lsattr -R \"${__UAC_MOUNT_POINT}/boot\"
lsattr -R \"${__UAC_MOUNT_POINT}/dev\"
lsattr -R \"${__UAC_MOUNT_POINT}/dir with spaces\"
lsattr -R \"${__UAC_MOUNT_POINT}/etc\"
lsattr -R \"${__UAC_MOUNT_POINT}/home\"
lsattr -R \"${__UAC_MOUNT_POINT}/lib\"
lsattr -R \"${__UAC_MOUNT_POINT}/media\"
lsattr -R \"${__UAC_MOUNT_POINT}/mnt\"
lsattr -R \"${__UAC_MOUNT_POINT}/opt\"
lsattr -R \"${__UAC_MOUNT_POINT}/proc\"
lsattr -R \"${__UAC_MOUNT_POINT}/run\"
lsattr -R \"${__UAC_MOUNT_POINT}/srv\"
lsattr -R \"${__UAC_MOUNT_POINT}/sys\"
lsattr -R \"${__UAC_MOUNT_POINT}/tmp\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr\"
lsattr -R \"${__UAC_MOUNT_POINT}/var\"" "${__test_container}"
}

test_lsattr_wrapper_exclude_paths_success()
{
  __test_container=`"${UAC_DIR}"/bin/linux/lsattr_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc"`
  assertEquals "lsattr \"${__UAC_MOUNT_POINT}\"
lsattr -R \"${__UAC_MOUNT_POINT}/bin\"
lsattr -R \"${__UAC_MOUNT_POINT}/boot\"
lsattr -R \"${__UAC_MOUNT_POINT}/dev\"
lsattr -R \"${__UAC_MOUNT_POINT}/dir with spaces\"
lsattr -R \"${__UAC_MOUNT_POINT}/etc\"
lsattr -R \"${__UAC_MOUNT_POINT}/home\"
lsattr -R \"${__UAC_MOUNT_POINT}/lib\"
lsattr -R \"${__UAC_MOUNT_POINT}/media\"
lsattr -R \"${__UAC_MOUNT_POINT}/mnt\"
lsattr -R \"${__UAC_MOUNT_POINT}/opt\"
lsattr -R \"${__UAC_MOUNT_POINT}/run\"
lsattr -R \"${__UAC_MOUNT_POINT}/srv\"
lsattr -R \"${__UAC_MOUNT_POINT}/sys\"
lsattr -R \"${__UAC_MOUNT_POINT}/tmp\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr\"
lsattr -R \"${__UAC_MOUNT_POINT}/var\"" "${__test_container}"

  __test_container=`"${UAC_DIR}"/bin/linux/lsattr_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr"`
  assertEquals "lsattr \"${__UAC_MOUNT_POINT}\"
lsattr -R \"${__UAC_MOUNT_POINT}/bin\"
lsattr -R \"${__UAC_MOUNT_POINT}/boot\"
lsattr -R \"${__UAC_MOUNT_POINT}/dev\"
lsattr -R \"${__UAC_MOUNT_POINT}/dir with spaces\"
lsattr -R \"${__UAC_MOUNT_POINT}/etc\"
lsattr -R \"${__UAC_MOUNT_POINT}/home\"
lsattr -R \"${__UAC_MOUNT_POINT}/lib\"
lsattr -R \"${__UAC_MOUNT_POINT}/media\"
lsattr -R \"${__UAC_MOUNT_POINT}/mnt\"
lsattr -R \"${__UAC_MOUNT_POINT}/opt\"
lsattr -R \"${__UAC_MOUNT_POINT}/run\"
lsattr -R \"${__UAC_MOUNT_POINT}/srv\"
lsattr -R \"${__UAC_MOUNT_POINT}/sys\"
lsattr -R \"${__UAC_MOUNT_POINT}/tmp\"
lsattr -R \"${__UAC_MOUNT_POINT}/var\"" "${__test_container}"

__test_container=`"${UAC_DIR}"/bin/linux/lsattr_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/dir with spaces"`
  assertEquals "lsattr \"${__UAC_MOUNT_POINT}\"
lsattr -R \"${__UAC_MOUNT_POINT}/bin\"
lsattr -R \"${__UAC_MOUNT_POINT}/boot\"
lsattr -R \"${__UAC_MOUNT_POINT}/dev\"
lsattr -R \"${__UAC_MOUNT_POINT}/etc\"
lsattr -R \"${__UAC_MOUNT_POINT}/home\"
lsattr -R \"${__UAC_MOUNT_POINT}/lib\"
lsattr -R \"${__UAC_MOUNT_POINT}/media\"
lsattr -R \"${__UAC_MOUNT_POINT}/mnt\"
lsattr -R \"${__UAC_MOUNT_POINT}/opt\"
lsattr -R \"${__UAC_MOUNT_POINT}/run\"
lsattr -R \"${__UAC_MOUNT_POINT}/srv\"
lsattr -R \"${__UAC_MOUNT_POINT}/sys\"
lsattr -R \"${__UAC_MOUNT_POINT}/tmp\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr\"
lsattr -R \"${__UAC_MOUNT_POINT}/var\"" "${__test_container}"

  __test_container=`"${UAC_DIR}"/bin/linux/lsattr_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib"`
  assertEquals "lsattr \"${__UAC_MOUNT_POINT}\"
lsattr -R \"${__UAC_MOUNT_POINT}/bin\"
lsattr -R \"${__UAC_MOUNT_POINT}/boot\"
lsattr -R \"${__UAC_MOUNT_POINT}/dev\"
lsattr -R \"${__UAC_MOUNT_POINT}/dir with spaces\"
lsattr -R \"${__UAC_MOUNT_POINT}/etc\"
lsattr -R \"${__UAC_MOUNT_POINT}/home\"
lsattr -R \"${__UAC_MOUNT_POINT}/lib\"
lsattr -R \"${__UAC_MOUNT_POINT}/media\"
lsattr -R \"${__UAC_MOUNT_POINT}/mnt\"
lsattr -R \"${__UAC_MOUNT_POINT}/opt\"
lsattr -R \"${__UAC_MOUNT_POINT}/run\"
lsattr -R \"${__UAC_MOUNT_POINT}/srv\"
lsattr -R \"${__UAC_MOUNT_POINT}/sys\"
lsattr -R \"${__UAC_MOUNT_POINT}/tmp\"
lsattr \"${__UAC_MOUNT_POINT}/usr\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/bin\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/include\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/lib64\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/local\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/sbin\"
lsattr -R \"${__UAC_MOUNT_POINT}/var\"" "${__test_container}"

  __test_container=`"${UAC_DIR}"/bin/linux/lsattr_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib/modules|${__UAC_MOUNT_POINT}/usr/local/bin"`
  assertEquals "lsattr \"${__UAC_MOUNT_POINT}\"
lsattr -R \"${__UAC_MOUNT_POINT}/bin\"
lsattr -R \"${__UAC_MOUNT_POINT}/boot\"
lsattr -R \"${__UAC_MOUNT_POINT}/dev\"
lsattr -R \"${__UAC_MOUNT_POINT}/dir with spaces\"
lsattr -R \"${__UAC_MOUNT_POINT}/etc\"
lsattr -R \"${__UAC_MOUNT_POINT}/home\"
lsattr -R \"${__UAC_MOUNT_POINT}/lib\"
lsattr -R \"${__UAC_MOUNT_POINT}/media\"
lsattr -R \"${__UAC_MOUNT_POINT}/mnt\"
lsattr -R \"${__UAC_MOUNT_POINT}/opt\"
lsattr -R \"${__UAC_MOUNT_POINT}/run\"
lsattr -R \"${__UAC_MOUNT_POINT}/srv\"
lsattr -R \"${__UAC_MOUNT_POINT}/sys\"
lsattr -R \"${__UAC_MOUNT_POINT}/tmp\"
lsattr \"${__UAC_MOUNT_POINT}/usr\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/bin\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/include\"
lsattr \"${__UAC_MOUNT_POINT}/usr/lib\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/lib/systemd\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/lib64\"
lsattr \"${__UAC_MOUNT_POINT}/usr/local\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/local/include\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/local/lib\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/local/share\"
lsattr -R \"${__UAC_MOUNT_POINT}/usr/sbin\"
lsattr -R \"${__UAC_MOUNT_POINT}/var\"" "${__test_container}"

__test_container=`"${UAC_DIR}"/bin/linux/lsattr_wrapper.sh "${__UAC_MOUNT_POINT}" "${__UAC_MOUNT_POINT}/proc|${__UAC_MOUNT_POINT}/usr/lib/modules|${__UAC_MOUNT_POINT}/usr/local/bin|${__UAC_MOUNT_POINT}/usr"`
  assertEquals "lsattr \"${__UAC_MOUNT_POINT}\"
lsattr -R \"${__UAC_MOUNT_POINT}/bin\"
lsattr -R \"${__UAC_MOUNT_POINT}/boot\"
lsattr -R \"${__UAC_MOUNT_POINT}/dev\"
lsattr -R \"${__UAC_MOUNT_POINT}/dir with spaces\"
lsattr -R \"${__UAC_MOUNT_POINT}/etc\"
lsattr -R \"${__UAC_MOUNT_POINT}/home\"
lsattr -R \"${__UAC_MOUNT_POINT}/lib\"
lsattr -R \"${__UAC_MOUNT_POINT}/media\"
lsattr -R \"${__UAC_MOUNT_POINT}/mnt\"
lsattr -R \"${__UAC_MOUNT_POINT}/opt\"
lsattr -R \"${__UAC_MOUNT_POINT}/run\"
lsattr -R \"${__UAC_MOUNT_POINT}/srv\"
lsattr -R \"${__UAC_MOUNT_POINT}/sys\"
lsattr -R \"${__UAC_MOUNT_POINT}/tmp\"
lsattr -R \"${__UAC_MOUNT_POINT}/var\"" "${__test_container}"

}