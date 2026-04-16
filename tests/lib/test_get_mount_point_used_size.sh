#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2034,SC2329

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_mount_point_used_size.sh"
}

# returns_error_when_no_operating_system_given
test_get_mount_point_used_size_returns_error_when_no_operating_system_given()
{
  assertFalse "_get_mount_point_used_size"
}

# returns_error_when_empty_string_given
test_get_mount_point_used_size_returns_error_when_empty_string_given()
{
  assertFalse "_get_mount_point_used_size ''"
}

# aix: parses used size from column 3 and mount point from column 7
test_get_mount_point_used_size_aix_returns_mount_point_and_used_size()
{
  df()
  {
    printf "%s\n" "Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on"
    printf "%s\n" "/dev/hd4           131072     90112   32%     4523    14% /"
    printf "%s\n" "/dev/hd2          1048576    524288   50%    32000    12% /usr"
  }

  __test_actual=`_get_mount_point_used_size "aix"`
  assertContains "${__test_actual}" "/|40960"
  assertContains "${__test_actual}" "/usr|524288"
}

# aix: skips rows where used column is a dash
test_get_mount_point_used_size_aix_skips_rows_with_dash_used()
{
  df()
  {
    printf "%s\n" "Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on"
    printf "%s\n" "/dev/hd4           131072        - 32%     4523    14% /tmp"
    printf "%s\n" "/dev/hd2          1048576   524288 50%    32000    12% /usr"
  }

  __test_actual=`_get_mount_point_used_size "aix"`
  assertNotContains "${__test_actual}" "/tmp|"
  assertContains "${__test_actual}" "/usr|"
}

# aix: skips header line only
test_get_mount_point_used_size_aix_skips_header_line()
{
  df()
  {
    printf "%s\n" "Filesystem    1024-blocks      Free %Used    Iused %Iused Mounted on"
  }

  __test_actual=`_get_mount_point_used_size "aix"`
  assertNull "${__test_actual}"
}

# esxi: parses used size from column 3 and mount point from column 6
test_get_mount_point_used_size_esxi_returns_mount_point_and_used_size()
{
  df()
  {
    printf "%s\n" "Filesystem     1K-blocks    Used Available Use% Mounted on"
    printf "%s\n" "VMFS-6         104857600 2097152 102760448   2% /vmfs/volumes/datastore1"
    printf "%s\n" "tmpfs             102400       0    102400   0% /tmp"
  }

  __test_actual=`_get_mount_point_used_size "esxi"`
  assertContains "${__test_actual}" "/vmfs/volumes/datastore1|2097152"
  assertContains "${__test_actual}" "/tmp|0"
}

# esxi: skips header line only
test_get_mount_point_used_size_esxi_skips_header_line()
{
  df()
  {
    printf "%s\n" "Filesystem     1K-blocks    Used Available Use% Mounted on"
  }

  __test_actual=`_get_mount_point_used_size "esxi"`
  assertNull "${__test_actual}"
}

# linux: parses used size from column 3 and mount point from last column
test_get_mount_point_used_size_linux_returns_mount_point_and_used_size()
{
  df()
  {
    printf "%s\n" "Filesystem     1K-blocks    Used Available Use% Mounted on"
    printf "%s\n" "/dev/sda1       20511312 5242880  14217960  27% /"
    printf "%s\n" "tmpfs             815956       0    815956   0% /dev/shm"
  }

  __test_actual=`_get_mount_point_used_size "linux"`
  assertContains "${__test_actual}" "/|5242880"
  assertContains "${__test_actual}" "/dev/shm|0"
}

# linux: skips header line only
test_get_mount_point_used_size_linux_skips_header_line()
{
  df()
  {
    printf "%s\n" "Filesystem     1K-blocks    Used Available Use% Mounted on"
  }

  __test_actual=`_get_mount_point_used_size "linux"`
  assertNull "${__test_actual}"
}

# macos: parses used size from column 3 and mount point from last column
test_get_mount_point_used_size_macos_returns_mount_point_and_used_size()
{
  df()
  {
    printf "%s\n" "Filesystem     1024-blocks      Used Available Capacity  iused ifree %iused  Mounted on"
    printf "%s\n" "/dev/disk1s1     976490568 524288000 394199576    58% 3459812 4294507467    0%   /"
    printf "%s\n" "devfs                  392       392         0   100%    1358         0  100%   /dev"
  }

  __test_actual=`_get_mount_point_used_size "macos"`
  assertContains "${__test_actual}" "/|524288000"
  assertContains "${__test_actual}" "/dev|392"
}

# freebsd: parses used size from column 3 and mount point from last column
test_get_mount_point_used_size_freebsd_returns_mount_point_and_used_size()
{
  df()
  {
    printf "%s\n" "Filesystem  1K-blocks     Used    Avail Capacity  Mounted on"
    printf "%s\n" "/dev/ada0p2  19307008  4194304 13567168    24%    /"
    printf "%s\n" "tmpfs          262144        0   262144     0%    /tmp"
  }

  __test_actual=`_get_mount_point_used_size "freebsd"`
  assertContains "${__test_actual}" "/|4194304"
  assertContains "${__test_actual}" "/tmp|0"
}

# netbsd: parses used size from column 3 and mount point from last column
test_get_mount_point_used_size_netbsd_returns_mount_point_and_used_size()
{
  df()
  {
    printf "%s\n" "Filesystem  1K-blocks     Used    Avail %Cap  Mounted on"
    printf "%s\n" "/dev/wd0a     4096000  1048576  2835456  27%  /"
  }

  __test_actual=`_get_mount_point_used_size "netbsd"`
  assertContains "${__test_actual}" "/|1048576"
}

# openbsd: parses used size from column 3 and mount point from last column
test_get_mount_point_used_size_openbsd_returns_mount_point_and_used_size()
{
  df()
  {
    printf "%s\n" "Filesystem  1K-blocks     Used    Avail Capacity  Mounted on"
    printf "%s\n" "/dev/sd0a     4096000  2097152  1896448    53%    /"
  }

  __test_actual=`_get_mount_point_used_size "openbsd"`
  assertContains "${__test_actual}" "/|2097152"
}

# solaris: parses used size from column 3 and mount point from last column
test_get_mount_point_used_size_solaris_returns_mount_point_and_used_size()
{
  df()
  {
    printf "%s\n" "Filesystem            1K-blocks     Used Available Use% Mounted on"
    printf "%s\n" "rpool/ROOT/solaris    20480000  8388608  11534336  43% /"
  }

  __test_actual=`_get_mount_point_used_size "solaris"`
  assertContains "${__test_actual}" "/|8388608"
}

# netscaler: parses used size from column 3 and mount point from last column
test_get_mount_point_used_size_netscaler_returns_mount_point_and_used_size()
{
  df()
  {
    printf "%s\n" "Filesystem  1K-blocks  Used  Available Use% Mounted on"
    printf "%s\n" "/dev/ad0s1a   1048576 65536     917504   7% /flash"
  }

  __test_actual=`_get_mount_point_used_size "netscaler"`
  assertContains "${__test_actual}" "/flash|65536"
}

# returns empty output for unknown operating system
test_get_mount_point_used_size_returns_empty_for_unknown_os()
{
  df()
  {
    printf "%s\n" "Filesystem  1K-blocks  Used Available Use% Mounted on"
    printf "%s\n" "/dev/sda1    20511312 5242880 14217960  27% /"
  }

  __test_actual=`_get_mount_point_used_size "windows"`
  assertNull "${__test_actual}"
}

# multiple mount points produce multiple output lines
test_get_mount_point_used_size_linux_returns_multiple_lines()
{
  df()
  {
    printf "%s\n" "Filesystem  1K-blocks    Used Available Use% Mounted on"
    printf "%s\n" "/dev/sda1   20511312  5242880  14217960  27% /"
    printf "%s\n" "/dev/sda2   10255656  1048576   8679112  11% /home"
    printf "%s\n" "tmpfs         815956        0    815956   0% /dev/shm"
  }

  __test_actual=`_get_mount_point_used_size "linux"`
  assertContains "${__test_actual}" "/|5242880"
  assertContains "${__test_actual}" "/home|1048576"
  assertContains "${__test_actual}" "/dev/shm|0"
}
