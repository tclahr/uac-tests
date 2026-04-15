#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2329

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_timezone.sh"

  # Stub _grep_o to mimic grep -o for MD5 hash extraction
  _grep_o()
  {
    grep -o "${1}"
  }

  # Stub __UAC_TOOL_MD5_BIN with a portable md5 command
  if command -v md5sum >/dev/null 2>&1; then
    __UAC_TOOL_MD5_BIN="md5sum"
  elif command -v md5 >/dev/null 2>&1; then
    __UAC_TOOL_MD5_BIN="md5"
  else
    __UAC_TOOL_MD5_BIN="md5sum"
  fi

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_get_timezone"
  mkdir -p "${__TEST_TEMP_DIR}"
}

# --- ESXi ---

test_get_timezone_returns_utc_for_esxi()
{
  __test_actual=`_get_timezone "/" "esxi"`
  assertEquals "UTC" "${__test_actual}"
}

test_get_timezone_returns_zero_for_esxi()
{
  _get_timezone "/" "esxi"
  assertTrue "[ $? -eq 0 ]"
}

# --- TZ environment variable (mount point = /) ---

test_get_timezone_returns_tz_env_when_set_on_root()
{
  __test_old_tz="${TZ:-}"
  TZ="America/New_York"
  __test_actual=`_get_timezone "/"`
  TZ="${__test_old_tz}"
  assertEquals "America/New_York" "${__test_actual}"
}

test_get_timezone_ignores_tz_env_when_mount_point_is_not_root()
{
  __test_old_tz="${TZ:-}"
  TZ="America/New_York"
  # Use a temp dir as a fake mount point with /etc/timezone
  __test_mp="${__TEST_TEMP_DIR}/mp_tz_ignored"
  mkdir -p "${__test_mp}/etc"
  printf "Europe/Berlin\n" >"${__test_mp}/etc/timezone"
  __test_actual=`_get_timezone "${__test_mp}"`
  TZ="${__test_old_tz}"
  assertEquals "Europe/Berlin" "${__test_actual}"
  rm -rf "${__test_mp}"
}

# --- /etc/localtime symlink pointing to zoneinfo ---

test_get_timezone_returns_timezone_from_localtime_symlink()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_symlink"
  mkdir -p "${__test_mp}/usr/share/zoneinfo/America"
  mkdir -p "${__test_mp}/etc"
  ln -sf "${__test_mp}/usr/share/zoneinfo/America/Chicago" \
    "${__test_mp}/etc/localtime"
  __test_actual=`_get_timezone "${__test_mp}" "linux"`
  assertEquals "America/Chicago" "${__test_actual}"
  rm -rf "${__test_mp}"
}

test_get_timezone_returns_zero_from_localtime_symlink()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_symlink_rc"
  mkdir -p "${__test_mp}/usr/share/zoneinfo/Europe"
  mkdir -p "${__test_mp}/etc"
  ln -sf "${__test_mp}/usr/share/zoneinfo/Europe/London" \
    "${__test_mp}/etc/localtime"
  _get_timezone "${__test_mp}" "linux"
  assertTrue "[ $? -eq 0 ]"
  rm -rf "${__test_mp}"
}

# --- /etc/timezone plain file ---

test_get_timezone_returns_timezone_from_etc_timezone_file()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_etc_timezone"
  mkdir -p "${__test_mp}/etc"
  printf "Asia/Tokyo\n" >"${__test_mp}/etc/timezone"
  __test_actual=`_get_timezone "${__test_mp}" "linux"`
  assertEquals "Asia/Tokyo" "${__test_actual}"
  rm -rf "${__test_mp}"
}

test_get_timezone_returns_zero_from_etc_timezone_file()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_etc_timezone_rc"
  mkdir -p "${__test_mp}/etc"
  printf "Asia/Tokyo\n" >"${__test_mp}/etc/timezone"
  _get_timezone "${__test_mp}" "linux"
  assertTrue "[ $? -eq 0 ]"
  rm -rf "${__test_mp}"
}

# --- AIX: /etc/environment ---

test_get_timezone_returns_timezone_from_aix_environment_file()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_aix"
  mkdir -p "${__test_mp}/etc"
  printf "TZ=America/Denver\n" >"${__test_mp}/etc/environment"
  __test_actual=`_get_timezone "${__test_mp}" "aix"`
  assertEquals "America/Denver" "${__test_actual}"
  rm -rf "${__test_mp}"
}

test_get_timezone_returns_timezone_from_aix_environment_file_with_quotes()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_aix_quotes"
  mkdir -p "${__test_mp}/etc"
  printf 'TZ="Pacific/Auckland"\n' >"${__test_mp}/etc/environment"
  __test_actual=`_get_timezone "${__test_mp}" "aix"`
  assertEquals "Pacific/Auckland" "${__test_actual}"
  rm -rf "${__test_mp}"
}

test_get_timezone_returns_zero_from_aix_environment_file()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_aix_rc"
  mkdir -p "${__test_mp}/etc"
  printf "TZ=America/Denver\n" >"${__test_mp}/etc/environment"
  _get_timezone "${__test_mp}" "aix"
  assertTrue "[ $? -eq 0 ]"
  rm -rf "${__test_mp}"
}

# --- Solaris: /etc/TIMEZONE ---

test_get_timezone_returns_timezone_from_solaris_timezone_file()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_solaris"
  mkdir -p "${__test_mp}/etc"
  printf "TZ=US/Mountain\n" >"${__test_mp}/etc/TIMEZONE"
  __test_actual=`_get_timezone "${__test_mp}" "solaris"`
  assertEquals "US/Mountain" "${__test_actual}"
  rm -rf "${__test_mp}"
}

test_get_timezone_returns_timezone_from_solaris_timezone_file_with_quotes()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_solaris_quotes"
  mkdir -p "${__test_mp}/etc"
  printf 'TZ="US/Eastern"\n' >"${__test_mp}/etc/TIMEZONE"
  __test_actual=`_get_timezone "${__test_mp}" "solaris"`
  assertEquals "US/Eastern" "${__test_actual}"
  rm -rf "${__test_mp}"
}

test_get_timezone_returns_zero_from_solaris_timezone_file()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_solaris_rc"
  mkdir -p "${__test_mp}/etc"
  printf "TZ=US/Mountain\n" >"${__test_mp}/etc/TIMEZONE"
  _get_timezone "${__test_mp}" "solaris"
  assertTrue "[ $? -eq 0 ]"
  rm -rf "${__test_mp}"
}

# --- OpenWRT: /etc/TZ ---

test_get_timezone_returns_timezone_from_openwrt_tz_file()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_openwrt"
  mkdir -p "${__test_mp}/etc"
  printf "UTC-8\n" >"${__test_mp}/etc/TZ"
  __test_actual=`_get_timezone "${__test_mp}" "linux"`
  assertEquals "UTC-8" "${__test_actual}"
  rm -rf "${__test_mp}"
}

test_get_timezone_returns_zero_from_openwrt_tz_file()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_openwrt_rc"
  mkdir -p "${__test_mp}/etc"
  printf "UTC-8\n" >"${__test_mp}/etc/TZ"
  _get_timezone "${__test_mp}" "linux"
  assertTrue "[ $? -eq 0 ]"
  rm -rf "${__test_mp}"
}

# --- Unknown / fallback ---

test_get_timezone_returns_unknown_when_no_source_found()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_empty"
  mkdir -p "${__test_mp}/etc"
  __test_actual=`_get_timezone "${__test_mp}" "linux"`
  assertEquals "unknown" "${__test_actual}"
  rm -rf "${__test_mp}"
}

test_get_timezone_returns_nonzero_when_no_source_found()
{
  __test_mp="${__TEST_TEMP_DIR}/mp_empty_rc"
  mkdir -p "${__test_mp}/etc"
  _get_timezone "${__test_mp}" "linux"
  assertFalse "[ $? -eq 0 ]"
  rm -rf "${__test_mp}"
}

# --- Default arguments ---

test_get_timezone_uses_root_as_default_mount_point()
{
  # When called with no arguments, function should not crash; output is
  # system-dependent so we just check it returns a non-empty string.
  __test_actual=`_get_timezone`
  assertNotNull "${__test_actual}"
}

test_get_timezone_uses_linux_as_default_operating_system()
{
  # Passing only a mount point without OS should default to linux path;
  # use a temp dir with /etc/timezone to produce a deterministic result.
  __test_mp="${__TEST_TEMP_DIR}/mp_default_os"
  mkdir -p "${__test_mp}/etc"
  printf "Europe/Paris\n" >"${__test_mp}/etc/timezone"
  __test_actual=`_get_timezone "${__test_mp}"`
  assertEquals "Europe/Paris" "${__test_actual}"
  rm -rf "${__test_mp}"
}