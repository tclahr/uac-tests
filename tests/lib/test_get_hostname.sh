#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_hostname.sh"

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_get_hostname"

  mkdir -p "${__TEST_TEMP_DIR}/etc"

}

setUp()
{
  HOSTNAME=""
  unset -f hostname
  unset -f uname
  unset -f head
  cat <<EOF >"${__TEST_TEMP_DIR}/etc/hostname"
johnsnow
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/etc/rc.conf"
hostname="sansastark"
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/etc/myname"
robstark
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/etc/nodename"
aryastark
EOF
  return 0
}

test_get_hostname_run_hostname_success()
{
  # stub
  hostname() { printf %b "johnsnow"; }

  __test_actual=`_get_hostname`
  assertEquals "johnsnow" "${__test_actual}"
}

test_get_hostname_run_uname_success()
{
  # stubs
  hostname() { return 1; }
  uname() { printf %b "johnsnow"; }

  __test_actual=`_get_hostname`
  assertEquals "johnsnow" "${__test_actual}"
}

test_get_hostname_HOSTNAME_var_success()
{
  # stubs
  hostname() { return 1; }
  uname() { return 1; }
  HOSTNAME="johnsnow"

  __test_actual=`_get_hostname`
  assertEquals "johnsnow" "${__test_actual}"
}

test_get_hostname_mount_point_etc_hostname_success()
{
  # stubs
  hostname() { return 1; }
  uname() { return 1; }
  rm -f "${__TEST_TEMP_DIR}/etc/rc.conf"
  rm -f "${__TEST_TEMP_DIR}/etc/myname"
  rm -f "${__TEST_TEMP_DIR}/etc/nodename"
  
  __test_actual=`_get_hostname "${__TEST_TEMP_DIR}"`
  assertEquals "johnsnow" "${__test_actual}"
}

test_get_hostname_mount_point_etc_rc_conf_success()
{
  # stubs
  hostname() { return 1; }
  uname() { return 1; }
  rm -f "${__TEST_TEMP_DIR}/etc/hostname"
  rm -f "${__TEST_TEMP_DIR}/etc/myname"
  rm -f "${__TEST_TEMP_DIR}/etc/nodename"
  
  __test_actual=`_get_hostname "${__TEST_TEMP_DIR}"`
  assertEquals "sansastark" "${__test_actual}"
}

test_get_hostname_mount_point_etc_myname_success()
{
  # stubs
  hostname() { return 1; }
  uname() { return 1; }
  rm -f "${__TEST_TEMP_DIR}/etc/hostname"
  rm -f "${__TEST_TEMP_DIR}/etc/rc.conf"
  rm -f "${__TEST_TEMP_DIR}/etc/nodename"
  
  __test_actual=`_get_hostname "${__TEST_TEMP_DIR}"`
  assertEquals "robstark" "${__test_actual}"
}

test_get_hostname_mount_point_etc_nodename_success()
{
  # stubs
  hostname() { return 1; }
  uname() { return 1; }
  rm -f "${__TEST_TEMP_DIR}/etc/hostname"
  rm -f "${__TEST_TEMP_DIR}/etc/rc.conf"
  rm -f "${__TEST_TEMP_DIR}/etc/myname"
  
  __test_actual=`_get_hostname "${__TEST_TEMP_DIR}"`
  assertEquals "aryastark" "${__test_actual}"
}

test_get_hostname_unknown_success()
{
  # stubs
  hostname() { return 1; }
  uname() { return 1; }
  
  __test_actual=`_get_hostname "/non-existent-mount-point"`
  assertEquals "unknown" "${__test_actual}"
}

test_get_hostname_defined_hostname_success()
{
  if [ -n "${TEST_SYSTEM_HOSTNAME:-}" ]; then
    __test_actual=`_get_hostname`
    assertEquals "${TEST_SYSTEM_HOSTNAME}" "${__test_actual}"
  else
    skipTest "TEST_SYSTEM_HOSTNAME not defined"
  fi
}