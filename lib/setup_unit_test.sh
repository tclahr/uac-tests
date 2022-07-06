#!/bin/sh

# shellcheck disable=SC2034

setup_unit_test()
{
  # set global vars
  GLOBAL_EXCLUDE_PATH_PATTERN=""
  GLOBAL_EXCLUDE_NAME_PATTERN=""
  GLOBAL_EXCLUDE_FILE_SYSTEM=""
  GLOBAL_EXCLUDE_MOUNT_POINT=""
  HASH_ALGORITHM=""
  ENABLE_FIND_MTIME=true
  ENABLE_FIND_ATIME=false
  ENABLE_FIND_CTIME=true
  START_DATE=""
  START_DATE_DAYS=""
  START_DATE_EPOCH=""
  END_DATE=""
  END_DATE_DAYS=""
  END_DATE_EPOCH=""
  UAC_VERSION="TEST"

  # build fake file system
  mkdir "${MOUNT_POINT}"
  
  # /bin
  mkdir -p "${MOUNT_POINT}/bin"
  echo "/bin/cp" >"${MOUNT_POINT}/bin/cp"
  echo "/bin/gpg.sh" >"${MOUNT_POINT}/bin/gpg.sh"
  echo "/bin/rm" >"${MOUNT_POINT}/bin/rm"
  echo "/bin/top" >"${MOUNT_POINT}/bin/top"
  echo "12345678901234567890123456789012345678901234567890" >"${MOUNT_POINT}/bin/fiftyb"
  chmod 777 "${MOUNT_POINT}/bin/cp"
  chmod 777 "${MOUNT_POINT}/bin/rm"

  # /usr/bin
  mkdir -p "${MOUNT_POINT}/usr/bin"
  echo "/usr/bin/host" >"${MOUNT_POINT}/usr/bin/host"
  echo "/usr/bin/ping" >"${MOUNT_POINT}/usr/bin/ping"
  echo "/usr/bin/pkill.sh" >"${MOUNT_POINT}/usr/bin/pkill.sh"
  echo "1234567890123456789012345678901234567890123456789012345678901234567890" >"${MOUNT_POINT}/bin/seventyb"
  chmod 755 "${MOUNT_POINT}/usr/bin/host"
  chmod 755 "${MOUNT_POINT}/usr/bin/ping"
  
  # /usr/lib
  mkdir -p "${MOUNT_POINT}/usr/lib"
  mkdir -p "${MOUNT_POINT}/usr/lib/empty"
  echo "/usr/lib/library.so.1" >"${MOUNT_POINT}/usr/lib/library.so.1"
  echo "/usr/lib/library.so.2" >"${MOUNT_POINT}/usr/lib/library.so.2"
  echo "/usr/lib/shared.so.1" >"${MOUNT_POINT}/usr/lib/shared.so.1"

  # /etc
  mkdir -p "${MOUNT_POINT}/etc/default"
  mkdir -p "${MOUNT_POINT}/etc/white space"
  mkdir -p "${MOUNT_POINT}/etc/double\"quotes"
  echo "skeletor" >"${MOUNT_POINT}/etc/hostname"
  echo "/etc/issue" >"${MOUNT_POINT}/etc/issue"
  echo "/etc/keyboard" >"${MOUNT_POINT}/etc/default/keyboard"
  echo "/etc/white space/file name" >"${MOUNT_POINT}/etc/white space/file name"
  echo "/etc/double\"quotes/file\"name" >"${MOUNT_POINT}/etc/double\"quotes/file\"name"
  cat << EOF >"${MOUNT_POINT}/etc/passwd"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
uac:x:1000:1000:uac:/home/uac:/bin/sh
mdatp:x:981:974::/home/mdatp:/sbin/nologin
kvmuser:x:979:972::/dev/null:/usr/sbin/false
EOF

  # /proc
  mkdir -p "${MOUNT_POINT}/proc/1"
  mkdir -p "${MOUNT_POINT}/proc/2"
  mkdir -p "${MOUNT_POINT}/proc/3"
  echo "1" >"${MOUNT_POINT}/proc/1/cmd"
  echo "2" >"${MOUNT_POINT}/proc/2/cmd"
  echo "3" >"${MOUNT_POINT}/proc/3/cmd"

  # /home
  if [ "${OPERATING_SYSTEM}" = "macos" ]; then
    mkdir -p "${MOUNT_POINT}/Users/skeletor"
    mkdir -p "${MOUNT_POINT}/Users/teela"
  elif [ "${OPERATING_SYSTEM}" = "solaris" ]; then
    mkdir -p "${MOUNT_POINT}/export/home/skeletor"
    mkdir -p "${MOUNT_POINT}/export/home/teela"
  else
    mkdir -p "${MOUNT_POINT}/home/skeletor"
    mkdir -p "${MOUNT_POINT}/home/teela"
  fi
  if [ "${OPERATING_SYSTEM}" = "linux" ]; then
    mkdir -p "${MOUNT_POINT}/home/.shadow" # ChomeOS
  fi

  check_available_system_tools >/dev/null 2>/dev/null

}
