#!/bin/sh

# shellcheck disable=SC2006,SC2317

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_parse_artifacts_file"
  mkdir -p "${TEMP_DATA_DIR}"

  command_collector() {
    cm_loop_command="${1:-}"
    cm_command="${2:-}"
    cm_root_output_directory="${3:-}"
    cm_output_directory="${4:-}"
    cm_output_file="${5:-}"
    cm_stderr_output_file="${6:-}"
    cm_compress_output_file="${7:-false}"

    printf %b "command_collector \"${cm_loop_command}\" \
\"${cm_command}\" \"${cm_root_output_directory}\" \"${cm_output_directory}\" \
\"${cm_output_file}\" \"${cm_stderr_output_file}\" \
\"${cm_compress_output_file}\"\n"
  }

  file_collector()
  {
    fl_path="${1:-}"
    shift
    fl_is_file_list="${1:-false}"
    shift
    fl_path_pattern="${1:-}"
    shift
    fl_name_pattern="${1:-}"
    shift
    fl_exclude_path_pattern="${1:-}"
    shift
    fl_exclude_name_pattern="${1:-}"
    shift
    fl_exclude_file_system="${1:-}"
    shift
    fl_max_depth="${1:-}"
    shift
    fl_file_type="${1:-}"
    shift
    fl_min_file_size="${1:-}"
    shift
    fl_max_file_size="${1:-}"
    shift
    fl_permissions="${1:-}"
    shift
    fl_ignore_date_range="${1:-false}"
    shift
    fl_root_output_directory="${1:-}"
    shift
    fl_output_file="${1:-}"

    printf %b "file_collector \"${fl_path}\" \"${fl_is_file_list}\" \
\"${fl_path_pattern}\" \"${fl_name_pattern}\" \"${fl_exclude_path_pattern}\" \
\"${fl_exclude_name_pattern}\" \"${fl_exclude_file_system}\" \
\"${fl_max_depth}\" \"${fl_file_type}\" \"${fl_min_file_size}\" \
\"${fl_max_file_size}\" \"${fl_permissions}\" \"${fl_ignore_date_range}\" \
\"${fl_root_output_directory}\" \"${fl_output_file}\"\n"
  }

  find_collector()
  {
    fm_path="${1:-}"
    shift
    fm_path_pattern="${1:-}"
    shift
    fm_name_pattern="${1:-}"
    shift
    fm_exclude_path_pattern="${1:-}"
    shift
    fm_exclude_name_pattern="${1:-}"
    shift
    fm_exclude_file_system="${1:-}"
    shift
    fm_max_depth="${1:-}"
    shift
    fm_file_type="${1:-}"
    shift
    fm_min_file_size="${1:-}"
    shift
    fm_max_file_size="${1:-}"
    shift
    fm_permissions="${1:-}"
    shift
    fm_ignore_date_range="${1:-false}"
    shift
    fm_root_output_directory="${1:-}"
    shift
    fm_output_directory="${1:-}"
    shift
    fm_output_file="${1:-}"
    shift
    fm_stderr_output_file="${1:-}"

    printf %b "find_collector \"${fm_path}\" \
\"${fm_path_pattern}\" \"${fm_name_pattern}\" \"${fm_exclude_path_pattern}\" \
\"${fm_exclude_name_pattern}\" \"${fm_exclude_file_system}\" \
\"${fm_max_depth}\" \"${fm_file_type}\" \"${fm_min_file_size}\" \
\"${fm_max_file_size}\" \"${fm_permissions}\" \"${fm_ignore_date_range}\" \
\"${fm_root_output_directory}\" \"${fm_output_directory}\" \
\"${fm_output_file}\" \"${fm_stderr_output_file}\"\n"
  }

  hash_collector()
  {
    hm_path="${1:-}"
    shift
    hm_is_file_list="${1:-false}"
    shift
    hm_path_pattern="${1:-}"
    shift
    hm_name_pattern="${1:-}"
    shift
    hm_exclude_path_pattern="${1:-}"
    shift
    hm_exclude_name_pattern="${1:-}"
    shift
    hm_exclude_file_system="${1:-}"
    shift
    hm_max_depth="${1:-}"
    shift
    hm_file_type="${1:-}"
    shift
    hm_min_file_size="${1:-}"
    shift
    hm_max_file_size="${1:-}"
    shift
    hm_permissions="${1:-}"
    shift
    hm_ignore_date_range="${1:-false}"
    shift
    hm_root_output_directory="${1:-}"
    shift
    hm_output_directory="${1:-}"
    shift
    hm_output_file="${1:-}"
    shift
    hm_stderr_output_file="${1:-}"

    printf %b "hash_collector \"${hm_path}\" \"${hm_is_file_list}\" \
\"${hm_path_pattern}\" \"${hm_name_pattern}\" \"${hm_exclude_path_pattern}\" \
\"${hm_exclude_name_pattern}\" \"${hm_exclude_file_system}\" \
\"${hm_max_depth}\" \"${hm_file_type}\" \"${hm_min_file_size}\" \
\"${hm_max_file_size}\" \"${hm_permissions}\" \"${hm_ignore_date_range}\" \
\"${hm_root_output_directory}\" \"${hm_output_directory}\" \
\"${hm_output_file}\" \"${hm_stderr_output_file}\"\n"
  }

  stat_collector()
  {
    sm_path="${1:-}"
    shift
    sm_is_file_list="${1:-false}"
    shift
    sm_path_pattern="${1:-}"
    shift
    sm_name_pattern="${1:-}"
    shift
    sm_exclude_path_pattern="${1:-}"
    shift
    sm_exclude_name_pattern="${1:-}"
    shift
    sm_exclude_file_system="${1:-}"
    shift
    sm_max_depth="${1:-}"
    shift
    sm_file_type="${1:-}"
    shift
    sm_min_file_size="${1:-}"
    shift
    sm_max_file_size="${1:-}"
    shift
    sm_permissions="${1:-}"
    shift
    sm_ignore_date_range="${1:-false}"
    shift
    sm_root_output_directory="${1:-}"
    shift
    sm_output_directory="${1:-}"
    shift
    sm_output_file="${1:-}"
    shift
    sm_stderr_output_file="${1:-}"

    printf %b "stat_collector \"${sm_path}\" \"${sm_is_file_list}\" \
\"${sm_path_pattern}\" \"${sm_name_pattern}\" \"${sm_exclude_path_pattern}\" \
\"${sm_exclude_name_pattern}\" \"${sm_exclude_file_system}\" \
\"${sm_max_depth}\" \"${sm_file_type}\" \"${sm_min_file_size}\" \
\"${sm_max_file_size}\" \"${sm_permissions}\" \"${sm_ignore_date_range}\" \
\"${sm_root_output_directory}\" \"${sm_output_directory}\" \
\"${sm_output_file}\" \"${sm_stderr_output_file}\"\n"
  }
}

# shellcheck disable=SC1091
shutdown_test() {
  # load UAC lib files
  . "${UAC_DIR}/lib/command_collector.sh"
  . "${UAC_DIR}/lib/find_collector.sh"
  . "${UAC_DIR}/lib/file_collector.sh"
  . "${UAC_DIR}/lib/hash_collector.sh"
  . "${UAC_DIR}/lib/stat_collector.sh"
}

before_each_test() {
  mkdir -p "${TEMP_DATA_DIR}/artifacts"
}

after_each_test() {
  rm -rf "${TEMP_DATA_DIR}/artifacts"
}

test_success_on_valid_command() {
  cat << EOF >>"${TEMP_DATA_DIR}/artifacts/01.yaml"
artifacts:
  -
    description: 01
    supported_os: [all]
    collector: command
    command: ps
    output_file: 01.txt
EOF
  _result=`parse_artifacts_file "${TEMP_DATA_DIR}/artifacts/01.yaml" "output_directory"`
  assert_equals "command_collector \"\" \"ps\" \"output_directory\" \"\" \"01.txt\" \"\" \"false\"" "${_result}"
}

test_success_on_valid_command_with_compression() {
  cat << EOF >>"${TEMP_DATA_DIR}/artifacts/01.yaml"
artifacts:
  -
    description: 01
    supported_os: [all]
    collector: command
    command: ps
    output_file: 01.txt
    compress_output_file: true
EOF
  _result=`parse_artifacts_file "${TEMP_DATA_DIR}/artifacts/01.yaml" "output_directory"`
  assert_equals "command_collector \"\" \"ps\" \"output_directory\" \"\" \"01.txt\" \"\" \"true\"" "${_result}"
}

test_success_on_valid_command_with_output_directory() {
  cat << EOF >>"${TEMP_DATA_DIR}/artifacts/01.yaml"
artifacts:
  -
    description: 01
    supported_os: [all]
    collector: command
    command: ps
    output_directory: subdir
    output_file: 01.txt
EOF
  _result=`parse_artifacts_file "${TEMP_DATA_DIR}/artifacts/01.yaml" "output_directory"`
  assert_equals "command_collector \"\" \"ps\" \"output_directory\" \"subdir\" \"01.txt\" \"\" \"false\"" "${_result}"
}

test_success_on_valid_command_with_stderr_output_file() {
  cat << EOF >>"${TEMP_DATA_DIR}/artifacts/01.yaml"
artifacts:
  -
    description: 01
    supported_os: [all]
    collector: command
    command: ps
    output_directory: subdir
    output_file: 01.txt
    stderr_output_file: custom.stderr
EOF
  _result=`parse_artifacts_file "${TEMP_DATA_DIR}/artifacts/01.yaml" "output_directory"`
  assert_equals "command_collector \"\" \"ps\" \"output_directory\" \"subdir\" \"01.txt\" \"custom.stderr\" \"false\"" "${_result}"
}

test_success_on_valid_loop_command() {
  cat << EOF >>"${TEMP_DATA_DIR}/artifacts/01.yaml"
artifacts:
  -
    description: 01
    supported_os: [all]
    collector: command
    loop_command: ls /proc
    command: ps
    output_file: 01.txt
EOF
  _result=`parse_artifacts_file "${TEMP_DATA_DIR}/artifacts/01.yaml" "output_directory"`
  assert_equals "command_collector \"ls /proc\" \"ps\" \"output_directory\" \"\" \"01.txt\" \"\" \"false\"" "${_result}"
}

test_success_on_valid_file() {
  cat << EOF >>"${TEMP_DATA_DIR}/artifacts/01.yaml"
artifacts:
  -
    description: 01
    supported_os: [all]
    collector: file
    path: /usr
    is_file_list: true
    path_pattern: ["/usr/bin"]
    name_pattern: ["*.txt"]
    exclude_path_pattern: [/usr/lib,/usr/share]
    exclude_name_pattern: [*.html]
    exclude_file_system: [apfs,ntfs]
    max_depth: 5
    file_type: d
    min_file_size: 1000
    max_file_size: 5000
    permissions: 755
    ignore_date_range: true
EOF
  _result=`parse_artifacts_file "${TEMP_DATA_DIR}/artifacts/01.yaml" "output_directory"`
  assert_equals "file_collector \"/usr\" \"true\" \"/usr/bin\" \"*.txt\" \"/usr/lib,/usr/share\" \"*.html\" \"apfs,ntfs\" \
\"5\" \"d\" \"1000\" \"5000\" \"755\" \"true\" \"output_directory\" \".files.tmp\"" "${_result}"
}

test_success_on_valid_find() {
  cat << EOF >>"${TEMP_DATA_DIR}/artifacts/01.yaml"
artifacts:
  -
    description: 01
    supported_os: [all]
    collector: find
    path: /usr
    path_pattern: ["/usr/bin"]
    name_pattern: ["*.txt"]
    exclude_path_pattern: [/usr/lib,/usr/share]
    exclude_name_pattern: [*.html]
    exclude_file_system: [apfs,ntfs]
    max_depth: 5
    file_type: d
    min_file_size: 1000
    max_file_size: 5000
    permissions: 755
    ignore_date_range: true
    output_directory: subdir   
    output_file: 01.txt
    stderr_output_file: 01.stderr
EOF
  _result=`parse_artifacts_file "${TEMP_DATA_DIR}/artifacts/01.yaml" "output_directory"`
  assert_equals "find_collector \"/usr\" \"/usr/bin\" \"*.txt\" \"/usr/lib,/usr/share\" \"*.html\" \"apfs,ntfs\" \
\"5\" \"d\" \"1000\" \"5000\" \"755\" \"true\" \"output_directory\" \"subdir\" \"01.txt\" \"01.stderr\"" "${_result}"
}

test_success_on_valid_hash() {
  cat << EOF >>"${TEMP_DATA_DIR}/artifacts/01.yaml"
artifacts:
  -
    description: 01
    supported_os: [all]
    collector: hash
    path: /usr
    is_file_list: true
    path_pattern: ["/usr/bin"]
    name_pattern: ["*.txt"]
    exclude_path_pattern: [/usr/lib,/usr/share]
    exclude_name_pattern: [*.html]
    exclude_file_system: [apfs,ntfs]
    max_depth: 5
    file_type: d
    min_file_size: 1000
    max_file_size: 5000
    permissions: 755
    ignore_date_range: true
    output_directory: subdir   
    output_file: 01.txt
    stderr_output_file: 01.stderr
EOF
  _result=`parse_artifacts_file "${TEMP_DATA_DIR}/artifacts/01.yaml" "output_directory"`
  assert_equals "hash_collector \"/usr\" \"true\" \"/usr/bin\" \"*.txt\" \"/usr/lib,/usr/share\" \"*.html\" \"apfs,ntfs\" \
\"5\" \"d\" \"1000\" \"5000\" \"755\" \"true\" \"output_directory\" \"subdir\" \"01.txt\" \"01.stderr\"" "${_result}"
}

test_success_on_valid_stat() {
  cat << EOF >>"${TEMP_DATA_DIR}/artifacts/01.yaml"
artifacts:
  -
    description: 01
    supported_os: [all]
    collector: stat
    path: /usr
    is_file_list: true
    path_pattern: ["/usr/bin"]
    name_pattern: ["*.txt"]
    exclude_path_pattern: [/usr/lib,/usr/share]
    exclude_name_pattern: [*.html]
    exclude_file_system: [apfs,ntfs]
    max_depth: 5
    file_type: d
    min_file_size: 1000
    max_file_size: 5000
    permissions: 755
    ignore_date_range: true
    output_directory: subdir   
    output_file: 01.txt
    stderr_output_file: 01.stderr
EOF
  _result=`parse_artifacts_file "${TEMP_DATA_DIR}/artifacts/01.yaml" "output_directory"`
  assert_equals "stat_collector \"/usr\" \"true\" \"/usr/bin\" \"*.txt\" \"/usr/lib,/usr/share\" \"*.html\" \"apfs,ntfs\" \
\"5\" \"d\" \"1000\" \"5000\" \"755\" \"true\" \"output_directory\" \"subdir\" \"01.txt\" \"01.stderr\"" "${_result}"
}