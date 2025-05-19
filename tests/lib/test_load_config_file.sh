#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/load_config_file.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  _is_in_list()
  {
    __il_element="${1:-}"
    __il_list="${2:-}"

    # shellcheck disable=SC2006
    __il_OIFS="${IFS}"; IFS="|"
    for __il_item in ${__il_list}; do
      if [ "${__il_element}" = "${__il_item}" ]; then
        IFS="${__il_OIFS}"
        return 0
      fi
    done
    
    IFS="${__il_OIFS}"
    return 1

  }

  _is_digit()
  {
    __id_number="${1:-empty}"

    if printf %b "${__id_number}" | grep -q -E "^[0-9]*$"; then
      return 0
    fi
    return 1
  }

  _array_to_psv()
  {
    # remove leading and trailing brackets [ ]
    # trim leading and trailing white space
    # replace escaped comma (\,) by #_COMMA_# string
    # remove white spaces between items
    # remove empty items
    # replace comma by pipe
    # replace #_COMMA_# string by comma
    # remove all single and double quotes
    sed -e 's|^ *\[||' \
        -e 's|\] *$||' \
        -e 's|^  *||' \
        -e 's|  *$||' \
        -e 's|\\,|#_COMMA_#|g' \
        -e 's| *,|,|g' \
        -e 's|, *|,|g' \
        -e 's|^,*||' \
        -e 's|,*$||' \
        -e 's|,,*|,|g' \
        -e 's:,:|:g' \
        -e 's|#_COMMA_#|,|g' \
        -e 's|"||g' \
        -e "s|'||g"

  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_load_config_file"

  mkdir -p "${__TEST_TEMP_DIR}/config"

}

setUp()
{
  # set default config values
  __UAC_CONF_EXCLUDE_PATH_PATTERN=""
  __UAC_CONF_EXCLUDE_NAME_PATTERN=""
  __UAC_CONF_EXCLUDE_FILE_SYSTEM="9p|afs|autofs|cifs"
  __UAC_CONF_HASH_ALGORITHM="md5|sha256"
  __UAC_CONF_MAX_DEPTH=0
  __UAC_CONF_ENABLE_FIND_MTIME=true
  __UAC_CONF_ENABLE_FIND_ATIME=true
  __UAC_CONF_ENABLE_FIND_CTIME=true
}

test_load_config_file_inconfig_file_fail()
{
  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/inconfig_file_fail.conf\""
}

test_load_config_file_exclude_path_pattern_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_path_pattern_success.conf"
# exclude_path_pattern: [ "/lib", "/home" ]
exclude_path_pattern: [ "/usr", "/etc" ]
# exclude_path_pattern: [ "/lib", "/home" ]
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/exclude_path_pattern_success.conf"
  assertEquals "/usr|/etc" "${__UAC_CONF_EXCLUDE_PATH_PATTERN}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_path_pattern_success.conf"
exclude_path_pattern: []
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/exclude_path_pattern_success.conf"
  assertNull "${__UAC_CONF_EXCLUDE_PATH_PATTERN}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_path_pattern_success.conf"
exclude_path_pattern: 
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/exclude_path_pattern_success.conf\""
}

test_load_config_file_exclude_name_pattern_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_name_pattern_success.conf"
exclude_name_pattern: [ "*.sh", "*.txt" ]
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/exclude_name_pattern_success.conf"
  assertEquals "*.sh|*.txt" "${__UAC_CONF_EXCLUDE_NAME_PATTERN}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_name_pattern_success.conf"
exclude_name_pattern: []
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/exclude_name_pattern_success.conf"
  assertNull "${__UAC_CONF_EXCLUDE_NAME_PATTERN}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_name_pattern_success.conf"
exclude_name_pattern: 
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/exclude_name_pattern_success.conf\""
}

test_load_config_file_exclude_file_system_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf"
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf"
  assertEquals "9p|afs|autofs|cifs" "${__UAC_CONF_EXCLUDE_FILE_SYSTEM}"

    cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf"
# exclude_file_system: [ btrfs, ext4, ntfs ]
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf"
  assertEquals "9p|afs|autofs|cifs" "${__UAC_CONF_EXCLUDE_FILE_SYSTEM}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf"
exclude_file_system: [ btrfs, ext4, ntfs ]
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf"
  assertEquals "btrfs|ext4|ntfs" "${__UAC_CONF_EXCLUDE_FILE_SYSTEM}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf"
exclude_file_system: []
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf"
  assertNull "${__UAC_CONF_EXCLUDE_FILE_SYSTEM}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf"
exclude_file_system: 
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/exclude_file_system_success.conf\""

}

test_load_config_file_hash_algorithm_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf"
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf"
  assertEquals "md5|sha256" "${__UAC_CONF_HASH_ALGORITHM}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf"
hash_algorithm: [ md5, sha1, sha256 ]
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf"
  assertEquals "md5|sha1|sha256" "${__UAC_CONF_HASH_ALGORITHM}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf"
hash_algorithm: []
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf"
  assertNull "${__UAC_CONF_HASH_ALGORITHM}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf"
hash_algorithm: 
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf\""

  cat <<EOF >"${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf"
hash_algorithm: [ md5, sha1, sha256, invalid ]
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/hash_algorithm_success.conf\""
}

test_load_config_file_max_depth_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/max_depth_success.conf"
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/max_depth_success.conf"
  assertEquals "0" "${__UAC_CONF_MAX_DEPTH}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/max_depth_success.conf"
max_depth: 2
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/max_depth_success.conf"
  assertEquals "2" "${__UAC_CONF_MAX_DEPTH}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/max_depth_success.conf"
max_depth: 0
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/max_depth_success.conf"
  assertEqual "0" "${__UAC_CONF_MAX_DEPTH}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/max_depth_success.conf"
max_depth: 
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/max_depth_success.conf\""

  cat <<EOF >"${__TEST_TEMP_DIR}/config/max_depth_success.conf"
max_depth: -1
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/max_depth_success.conf\""
}

test_load_config_file_enable_find_mtime_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_mtime_success.conf"
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_mtime_success.conf"
  assertTrue "${__UAC_CONF_ENABLE_FIND_MTIME}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_mtime_success.conf"
enable_find_mtime: false
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_mtime_success.conf"
  assertFalse "${__UAC_CONF_ENABLE_FIND_MTIME}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_mtime_success.conf"
enable_find_mtime: 
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/enable_find_mtime_success.conf\""

  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_mtime_success.conf"
enable_find_mtime: invalid
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/enable_find_mtime_success.conf\""
}

test_load_config_file_enable_find_atime_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_atime_success.conf"
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_atime_success.conf"
  assertTrue "${__UAC_CONF_ENABLE_FIND_ATIME}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_atime_success.conf"
enable_find_atime: false
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_atime_success.conf"
  assertFalse "${__UAC_CONF_ENABLE_FIND_ATIME}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_atime_success.conf"
enable_find_atime: 
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/enable_find_atime_success.conf\""

  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_atime_success.conf"
enable_find_atime: invalid
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/enable_find_atime_success.conf\""
}

test_load_config_file_enable_find_ctime_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_ctime_success.conf"
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_ctime_success.conf"
  assertTrue "${__UAC_CONF_ENABLE_FIND_CTIME}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_ctime_success.conf"
enable_find_ctime: false
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_ctime_success.conf"
  assertFalse "${__UAC_CONF_ENABLE_FIND_CTIME}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_ctime_success.conf"
enable_find_ctime: 
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/enable_find_ctime_success.conf\""

  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_ctime_success.conf"
enable_find_ctime: invalid
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/enable_find_ctime_success.conf\""
}

test_load_config_file_multiple_config_files_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/multiple_config_files_success_01.conf"
exclude_path_pattern: [ "/lib", "/home" ]
exclude_name_pattern: []
exclude_file_system: [ btrfs, ext4, ntfs ]
hash_algorithm: [ md5, sha1 ]
max_depth: 0
enable_find_mtime: true
enable_find_atime: false
enable_find_ctime: true
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/multiple_config_files_success_01.conf"
  assertEquals "/lib|/home" "${__UAC_CONF_EXCLUDE_PATH_PATTERN}"
  assertNull "${__UAC_CONF_EXCLUDE_NAME_PATTERN}"
  assertEquals "btrfs|ext4|ntfs" "${__UAC_CONF_EXCLUDE_FILE_SYSTEM}"
  assertEquals "md5|sha1" "${__UAC_CONF_HASH_ALGORITHM}"
  assertEquals "0" "${__UAC_CONF_MAX_DEPTH}"
  assertTrue "${__UAC_CONF_ENABLE_FIND_MTIME}"
  assertFalse "${__UAC_CONF_ENABLE_FIND_ATIME}"
  assertTrue "${__UAC_CONF_ENABLE_FIND_CTIME}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/multiple_config_files_success_02.conf"
exclude_name_pattern: [ "*.html", "*.c" ]
max_depth: 5
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/multiple_config_files_success_02.conf"
  assertEquals "/lib|/home" "${__UAC_CONF_EXCLUDE_PATH_PATTERN}"
  assertEquals "*.html|*.c" "${__UAC_CONF_EXCLUDE_NAME_PATTERN}"
  assertEquals "btrfs|ext4|ntfs" "${__UAC_CONF_EXCLUDE_FILE_SYSTEM}"
  assertEquals "md5|sha1" "${__UAC_CONF_HASH_ALGORITHM}"
  assertEquals "5" "${__UAC_CONF_MAX_DEPTH}"
  assertTrue "${__UAC_CONF_ENABLE_FIND_MTIME}"
  assertFalse "${__UAC_CONF_ENABLE_FIND_ATIME}"
  assertTrue "${__UAC_CONF_ENABLE_FIND_CTIME}"

}
