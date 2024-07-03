#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_mount_point_by_file_system.sh"
}

test_get_mount_point_by_file_system_aix_success()
{
  # stub
  mount() {
    cat << EOF
node       mounted        mounted over    vfs       date        options      
-------- ---------------  ---------------  ------ ------------ --------------- 
      /dev/hd4         /                jfs2   Apr 19 07:48 rw,log=/dev/hd8 
      /dev/hd2         /usr             jfs2   Apr 19 07:48 rw,log=/dev/hd8 
      /dev/hd9var      /var             jfs2   Apr 19 07:48 rw,log=/dev/hd8 
      /dev/hd3         /tmp             jfs2   Apr 19 07:48 rw,log=/dev/hd8 
      /dev/hd1         /home            jfs2   Apr 19 07:48 rw,log=/dev/hd8 
      /dev/hd11admin   /admin           jfs2   Apr 19 07:48 rw,log=/dev/hd8 
      /dev/uac1        /test/uac_file_system/01 uacfs Apr 19 07:48 rw,log=/dev/uac1 
      /proc            /proc            procfs Apr 19 07:48 rw              
      /dev/hd10opt     /opt             jfs2   Apr 19 07:48 rw,log=/dev/hd8 
      /dev/livedump    /var/adm/ras/livedump jfs2   Apr 19 07:48 rw,log=/dev/hd8 
      /dev/hd5         /uacfs            ahafs   Apr 19 07:48 rw,log=/dev/hd8 
      /ahafs           /aha             ahafs  Apr 19 07:49 rw              
      /etc/auto.project /cecc/project    autofs Apr 19 07:53 ignore          
      /etc/auto.persist /cecc/persist    autofs Apr 19 07:53 ignore          
      /dev/uac2        /test/uac_file_system/02 uacfs Apr 19 07:49 rw,log=/dev/uac2 
      /etc/auto.aix    /cecc/repos/aix73 autofs Apr 19 07:53 ignore          
      /etc/auto.lpp    /cecc/repos/lpp  autofs Apr 19 07:53 ignore
EOF
  }

  __test_actual=`_get_mount_point_by_file_system "uacfs|procfs" "aix"`
  assertEquals "/test/uac_file_system/01|/proc|/test/uac_file_system/02" "${__test_actual}"
}

test_get_mount_point_by_file_system_esxi_success()
{
  # stub
  df() {
    cat << EOF
Filesystem       Bytes        Used   Available Use% Mounted on
VMFS-6     34896609280 19042140160 15854469120  55% /vmfs/volumes/61e95515-2b1898a6-7d46-52540068951b
vfat         261853184   155602944   106250240  59% /vmfs/volumes/bcf64379-9e169254-958b-615a95e902cc
uacfs        299712512   182263808   117448704  61% /test/uac_file_system/01
procfs       299712512   182263808   182263808   0% /proc
vfat        4293591040    19464192  4274126848   0% /uacfs
uacfs        261853184        4096   261849088   0% /test/uac_file_system/02
EOF
  }

  __test_actual=`_get_mount_point_by_file_system "uacfs|procfs" "esxi"`
  assertEquals "/test/uac_file_system/01|/proc|/test/uac_file_system/02" "${__test_actual}"
}

test_get_mount_point_by_file_system_freebsd_macos_netscaler_success()
{
  # stub
  mount() {
    cat << EOF
/dev/disk1s5s1 on / (apfs, sealed, local, read-only, journaled)
devfs on /dev (devfs, local, nobrowse)
/dev/uac1s1 on /test/uac_file_system/01 (uacfs, local, noexec, journaled, noatime, nobrowse)
/dev/disk1s4 on /System/Volumes/VM (apfs, local, noexec, journaled, noatime, nobrowse)
/dev/disk1s2 on /System/Volumes/Preboot (apfs, local, journaled, nobrowse)
/dev/disk1s6 on /System/Volumes/Update (apfs, local, journaled, nobrowse)
procfs on /proc (procfs, local, automonted)
/dev/disk1s1 on /System/Volumes/Data (apfs, local, journaled, nobrowse)
map auto_home on /System/Volumes/Data/home (autofs, automounted, nobrowse)
/dev/uac1s2 on /test/uac_file_system/02 (uacfs, local, soft-updates)
/dev/gpt/rootfs on / (ufs, local, soft-updates)
devfs on /dev (devfs, local, multilabel)
EOF
  }

  __test_actual=`_get_mount_point_by_file_system "uacfs|procfs" "freebsd"`
  assertEquals "/test/uac_file_system/01|/proc|/test/uac_file_system/02" "${__test_actual}"
  __test_actual=`_get_mount_point_by_file_system "uacfs|procfs" "macos"`
  assertEquals "/test/uac_file_system/01|/proc|/test/uac_file_system/02" "${__test_actual}"
  __test_actual=`_get_mount_point_by_file_system "uacfs|procfs" "netscaler"`
  assertEquals "/test/uac_file_system/01|/proc|/test/uac_file_system/02" "${__test_actual}"
}

test_get_mount_point_by_file_system_linux_netbsd_openbsd_success()
{
  # stub
  mount() {
    cat << EOF
sys on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
/dev/uac1 on /test/uac_file_system/01 type uacfs (rw,nosuid,nodev,noexec,relatime)
dev on /dev type devtmpfs (rw,nosuid,relatime,size=4063528k,nr_inodes=1015882,mode=755,inode64)
run on /run type tmpfs (rw,nosuid,nodev,relatime,mode=755,inode64)
/dev/vda1 on / type btrfs (rw,noatime,compress=zstd:3,space_cache=v2,autodefrag,subvolid=256,subvol=/@)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,inode64)
mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime)
ramfs on /run/credentials/systemd-sysusers.service type ramfs (ro,nosuid,nodev,noexec,relatime,mode=700)
proc on /proc type procfs (rw,nosuid,nodev,noexec,relatime)
/dev/vda1 on /home type btrfs (rw,noatime,compress=zstd:3,space_cache=v2,autodefrag,subvolid=257,subvol=/@home)
/dev/uac2 on /test/uac_file_system/02 type uacfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev,nr_inodes=1048576,inode64)
/dev/vda1 on /var/log type btrfs (rw,noatime,compress=zstd:3,space_cache=v2,autodefrag,subvolid=259,subvol=/@log)
/dev/vda1 on /var/cache type btrfs (rw,noatime,compress=zstd:3,space_cache=v2,autodefrag,subvolid=258,subvol=/@cache)
tmpfs on /run/user/1000 type tmpfs (rw,nosuid,nodev,relatime,size=814088k,nr_inodes=203522,mode=700,uid=1000,gid=1000,inode64)
gvfsd-fuse on /run/user/1000/gvfs type fuse.gvfsd-fuse (rw,nosuid,nodev,relatime,user_id=1000,group_id=1000)
EOF
  }

  __test_actual=`_get_mount_point_by_file_system "uacfs|procfs" "linux"`
  assertEquals "/test/uac_file_system/01|/proc|/test/uac_file_system/02" "${__test_actual}"
  __test_actual=`_get_mount_point_by_file_system "uacfs|procfs" "netbsd"`
  assertEquals "/test/uac_file_system/01|/proc|/test/uac_file_system/02" "${__test_actual}"
  __test_actual=`_get_mount_point_by_file_system "uacfs|procfs" "openbsd"`
  assertEquals "/test/uac_file_system/01|/proc|/test/uac_file_system/02" "${__test_actual}"
}

test_get_mount_point_by_file_system_solaris_success()
{
  # stub
  df() {
    cat << EOF
/                  : ufs     
/devices           : devfs   
/system/contract   : ctfs    
/etc/svc/volatile  : tmpfs   
/system/object     : objfs   
/etc/dfs/sharetab  : sharefs 
/test/uac_file_system/01 : uacfs
/lib/libc.so.1     : lofs    
/proc              : procfs    
/dev/fd            : fd      
/tmp               : tmpfs   
/var/run           : tmpfs   
/test/uac_file_system/02 : uacfs
/export/home       : ufs     
EOF
  }

  __test_actual=`_get_mount_point_by_file_system "uacfs|procfs" "solaris"`
  assertEquals "/test/uac_file_system/01|/proc|/test/uac_file_system/02" "${__test_actual}"
}

test_get_mount_point_by_file_system_invalid_file_system_fail()
{
  # stub
  df() {
    cat << EOF
/                  : ufs     
/devices           : devfs   
/system/contract   : ctfs    
/etc/svc/volatile  : tmpfs   
/system/object     : objfs   
/etc/dfs/sharetab  : sharefs 
/test/uac_file_system/01 : uacfs
/lib/libc.so.1     : lofs    
/proc              : procfs    
/dev/fd            : fd      
/tmp               : tmpfs   
/var/run           : tmpfs   
/test/uac_file_system/02 : uacfs
/export/home       : ufs     
EOF
  }

  __test_actual=`_get_mount_point_by_file_system "invalid" "solaris"`
  assertNull "${__test_actual}"
}

test_get_mount_point_by_file_system_empty_file_system_list_fail()
{
  assertFalse "_get_mount_point_by_file_system \"\" \"solaris\""
}

test_get_mount_point_by_file_system_empty_operating_system_fail()
{
  assertFalse "_get_mount_point_by_file_system \"uacfs|procfs\" \"\""
}