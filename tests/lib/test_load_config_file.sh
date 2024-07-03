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
    return 0
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
  __UAC_CONF_EXCLUDE_FILE_SYSTEM=""
  __UAC_CONF_HASH_ALGORITHM="md5|sha1"
  __UAC_CONF_MAX_DEPTH=0
    __UAC_CONF_ENABLE_FIND_MTIME=true
  __UAC_CONF_ENABLE_FIND_ATIME=false
  __UAC_CONF_ENABLE_FIND_CTIME=true
}

test_load_config_file_invalid_config_file_fail()
{
  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/invalid_config_file_fail.conf\""
}

test_load_config_file_empty_exclude_path_pattern_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/empty_exclude_path_pattern_success.conf"
exclude_path_pattern: 
hash_algorithm: [md5, sha1]
max_depth: 0
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/empty_exclude_path_pattern_success.conf"
  assertNull "${__UAC_CONF_EXCLUDE_PATH_PATTERN}"
}

test_load_config_file_valid_exclude_path_pattern_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/valid_exclude_path_pattern_success.conf"
exclude_path_pattern: [ "/usr", "/etc" ]
hash_algorithm: [md5, sha1]
max_depth: 0
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/valid_exclude_path_pattern_success.conf"
  assertEquals "/usr|/etc" "${__UAC_CONF_EXCLUDE_PATH_PATTERN}"
}

test_load_config_file_valid_exclude_path_pattern_with_leading_and_trailing_spaces_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/valid_exclude_path_pattern_success.conf"
exclude_path_pattern: [ "/usr  ", "  /etc  " ]
hash_algorithm: [md5, sha1]
max_depth: 0
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/valid_exclude_path_pattern_success.conf"
  assertEquals "/usr  |  /etc  " "${__UAC_CONF_EXCLUDE_PATH_PATTERN}"
}

test_load_config_file_empty_exclude_name_pattern_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/empty_exclude_name_pattern_success.conf"
exclude_name_pattern: 
hash_algorithm: [md5, sha1]
max_depth: 0
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/empty_exclude_name_pattern_success.conf"
  assertNull "${__UAC_CONF_EXCLUDE_NAME_PATTERN}"
}

test_load_config_file_valid_exclude_name_pattern_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/valid_exclude_name_pattern_success.conf"
exclude_name_pattern: [ "*.sh", "*.txt" ]
hash_algorithm: [md5, sha1]
max_depth: 0
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/valid_exclude_name_pattern_success.conf"
  assertEquals "*.sh|*.txt" "${__UAC_CONF_EXCLUDE_NAME_PATTERN}"
}

test_load_config_file_empty_exclude_file_system_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/empty_exclude_file_system_success.conf"
exclude_file_system: 
hash_algorithm: [md5, sha1]
max_depth: 0
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/empty_exclude_file_system_success.conf"
  assertNull "${__UAC_CONF_EXCLUDE_FILE_SYSTEM}"
}

test_load_config_file_valid_exclude_file_system_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/valid_exclude_file_system_success.conf"
exclude_file_system: [ btrfs, ext4, ntfs ]
hash_algorithm: [md5, sha1]
max_depth: 0
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/valid_exclude_file_system_success.conf"
  assertEquals "btrfs|ext4|ntfs" "${__UAC_CONF_EXCLUDE_FILE_SYSTEM}"
}

test_load_config_file_empty_hash_algorithm_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/empty_hash_algorithm_fail.conf"
hash_algorithm: []
max_depth: 0
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/empty_hash_algorithm_fail.conf"
  assertEquals "md5|sha1" "${__UAC_CONF_HASH_ALGORITHM}"
}

test_load_config_file_max_depth_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/max_depth_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0  
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/max_depth_success.conf"
  assertEquals "0" "${__UAC_CONF_MAX_DEPTH}"

  cat <<EOF >"${__TEST_TEMP_DIR}/config/max_depth_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 5  
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/max_depth_success.conf"
  assertEquals "5" "${__UAC_CONF_MAX_DEPTH}"
}

test_load_config_file_invalid_max_depth_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/invalid_max_depth_fail.conf"
hash_algorithm: [md5, sha1]
max_depth: invalid   
EOF

  assertFalse "_load_config_file \"${__TEST_TEMP_DIR}/config/invalid_max_depth_fail.conf\""

  cat <<EOF >"${__TEST_TEMP_DIR}/config/invalid_max_depth_fail.conf"
hash_algorithm: [md5, sha1]
max_depth:  
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/invalid_max_depth_fail.conf"
  assertEquals "0" "${__UAC_CONF_MAX_DEPTH}" 
}

test_load_config_file_enable_find_mtime_true_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_mtime_true_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0
xargs_max_procs: 2
enable_find_mtime: true
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_mtime_true_success.conf"
  assertTrue "${__UAC_CONF_ENABLE_FIND_MTIME}"
}

test_load_config_file_enable_find_mtime_false_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_mtime_false_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0
xargs_max_procs: 2
enable_find_mtime: false
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_mtime_false_success.conf"
  assertFalse "${__UAC_CONF_ENABLE_FIND_MTIME}"
}

test_load_config_file_invalid_enable_find_mtime_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/invalid_enable_find_mtime_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0
xargs_max_procs: 2
enable_find_mtime: invalid
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/invalid_enable_find_mtime_success.conf"
  assertFalse "${__UAC_CONF_ENABLE_FIND_MTIME}"
}

test_load_config_file_enable_find_atime_true_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_atime_true_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0
xargs_max_procs: 2
enable_find_atime: true
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_atime_true_success.conf"
  assertTrue "${__UAC_CONF_ENABLE_FIND_ATIME}"
}

test_load_config_file_enable_find_atime_false_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_atime_false_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0
xargs_max_procs: 2
enable_find_atime: false
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_atime_false_success.conf"
  assertFalse "${__UAC_CONF_ENABLE_FIND_ATIME}"
}

test_load_config_file_invalid_enable_find_atime_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/invalid_enable_find_atime_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0
xargs_max_procs: 2
enable_find_atime: invalid
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/invalid_enable_find_atime_success.conf"
  assertFalse "${__UAC_CONF_ENABLE_FIND_ATIME}"
}

test_load_config_file_enable_find_ctime_true_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_ctime_true_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0
xargs_max_procs: 2
enable_find_ctime: true
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_ctime_true_success.conf"
  assertTrue "${__UAC_CONF_ENABLE_FIND_CTIME}"
}

test_load_config_file_enable_find_ctime_false_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/enable_find_ctime_false_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0
xargs_max_procs: 2
enable_find_ctime: false
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/enable_find_ctime_false_success.conf"
  assertFalse "${__UAC_CONF_ENABLE_FIND_CTIME}"
}

test_load_config_file_invalid_enable_find_ctime_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/config/invalid_enable_find_ctime_success.conf"
hash_algorithm: [md5, sha1]
max_depth: 0
xargs_max_procs: 2
enable_find_ctime: invalid
EOF

  _load_config_file "${__TEST_TEMP_DIR}/config/invalid_enable_find_ctime_success.conf"
  assertFalse "${__UAC_CONF_ENABLE_FIND_CTIME}"
}