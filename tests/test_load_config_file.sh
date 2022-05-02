#!/bin/sh

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_load_config_file"
  mkdir -p "${TEMP_DATA_DIR}"

  cat << EOF >"${TEMP_DATA_DIR}/uac.conf"
# UAC configuration file

# Directory/path patterns that will be excluded from 'find', 'stat', 'hash' and 
# 'file' collectors.
# As 'find' tool is used to search for files and directories, the path 
# patterns below need to be compatible with '-path' option. Please check 
# 'find' man pages for more information.
# Example: ["/etc", "/usr/*/local", "*/log"]
exclude_path_pattern: [/usr/bin, /etc]

# Directory/path patterns that will be excluded from 'find', 'stat', 'hash' and 
# 'file' collectors.
# As 'find' tool is used to search for files and directories, the file name
# patterns below need to be compatible with '-name' option. Please check 
# 'find' man pages for more information.
# Example: ["/etc/passwd", "*.txt", "*.gz.*", "*.[Ll][Oo][Gg]"]
exclude_name_pattern: ["*.txt","*.gz"]

# File systems that will be excluded from 'find', 'stat', 'hash' and 
# 'file' collectors.
# UAC will retrieve the list of existing mountpoints (paths) and add them 
# to the exclusion list automatically.
# The file system types which are supported depend on the target computer's 
# running kernel.
exclude_file_system: [9p, afs, autofs]

# hash algorithms
# Accepted values: md5, sha1 and sha256
hash_algorithm: [md5, sha1]

# Limit data collection based on the date range provided.
# UAC uses find's '-mtime', '-atime' and '-ctime' options to limit the data
# collection based on the file/directory last accessed, last modified and last 
# status changed dates.
# Example 1:
#   to collect only files which data was last modified OR status last 
#   changed within the given date range, please set enable_find_mtime and 
#   enable_find_ctime to true and enable_find_atime to false.
# Example 2:
#   to collect only files which last status was changed within the date
#   range, please set enable_find_ctime to true, and enable_find_atime and
#   enable_find_mtime to false.
# Accepted values: true or false
enable_find_atime: false
enable_find_mtime: true
enable_find_ctime: true
EOF
}

shutdown_test() {
  return 0
}

before_each_test() {
  return 0
}

after_each_test() {
  return 0
}

test_load_test_config_file() {
  assert "load_config_file \"${TEMP_DATA_DIR}/uac.conf\""
}

test_no_config_file() {
  assert_fails "load_config_file \"${TEMP_DATA_DIR}/no.conf\""
}

test_set_global_exclude_path_pattern() {
  load_config_file "${TEMP_DATA_DIR}/uac.conf"
  assert_equals "${GLOBAL_EXCLUDE_PATH_PATTERN}" "/usr/bin,/etc"
}

test_set_global_exclude_name_pattern() {
  load_config_file "${TEMP_DATA_DIR}/uac.conf"
  assert_equals "${GLOBAL_EXCLUDE_NAME_PATTERN}" "*.txt,*.gz"
}

test_set_global_exclude_file_system() {
  load_config_file "${TEMP_DATA_DIR}/uac.conf"
  assert_equals "${GLOBAL_EXCLUDE_FILE_SYSTEM}" "9p,afs,autofs"
}

test_set_hash_algorithm() {
  load_config_file "${TEMP_DATA_DIR}/uac.conf"
  assert_equals "${HASH_ALGORITHM}" "md5,sha1"
}

test_set_enable_find_atime() {
  load_config_file "${TEMP_DATA_DIR}/uac.conf"
  assert_equals "${ENABLE_FIND_ATIME}" "false"
}

test_set_enable_find_mtime() {
  load_config_file "${TEMP_DATA_DIR}/uac.conf"
  assert_equals "${ENABLE_FIND_MTIME}" "true"
}

test_set_enable_find_ctime() {
  load_config_file "${TEMP_DATA_DIR}/uac.conf"
  assert_equals "${ENABLE_FIND_CTIME}" "true"
}

test_empty_hash_algorithm() {
  cat << EOF >"${TEMP_DATA_DIR}/empty_hash_algorithm.conf"
exclude_path_pattern: [/usr/bin, /etc]
exclude_name_pattern: ["*.txt","*.gz"]
exclude_file_system: [9p, afs, autofs]
hash_algorithm: []
enable_find_atime: false
enable_find_mtime: true
enable_find_ctime: true
EOF
  assert_fails "load_config_file \"${TEMP_DATA_DIR}/empty_hash_algorithm.conf\""
}

test_invalid_hash_algorithm() {
  cat << EOF >"${TEMP_DATA_DIR}/invalid_hash_algorithm.conf"
exclude_path_pattern: [/usr/bin, /etc]
exclude_name_pattern: ["*.txt","*.gz"]
exclude_file_system: [9p, afs, autofs]
hash_algorithm: [md5, invalid]
enable_find_atime: false
enable_find_mtime: true
enable_find_ctime: true
EOF
  assert_fails "load_config_file \"${TEMP_DATA_DIR}/invalid_hash_algorithm.conf\""
}