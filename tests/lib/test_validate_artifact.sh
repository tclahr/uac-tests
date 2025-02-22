#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/validate_artifact.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  _is_in_list()
  {
    __il_element="${1:-}"
    __il_list="${2:-}"

    for __il_item in `printf %b "${__il_list}" | sed -e 's:|: :g'`; do
      if [ "${__il_element}" = "${__il_item}" ]; then
        return 0
      fi
    done
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

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_validate_artifact"

  mkdir -p "${__TEST_TEMP_DIR}/artifacts"

}

test_validate_artifact_invalid_artifact_fail()
{
  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_artifact_fail.yaml\""
}

test_validate_artifact_duplicate_artifacts_prop_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/duplicate_artifacts_prop_fail.yaml"
version: 1.0
artifacts:
  -
artifacts:
  -
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/duplicate_artifacts_prop_fail.yaml\""
}

test_validate_artifact_artifacts_prop_mappings_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/artifacts_prop_mappings_fail.yaml"
version: 1.0
artifacts:
  description: example 1
  supported_os: [all]
  collector: command
  command: ls
  output_directory: /tmp
  output_file: ls.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/artifacts_prop_mappings_fail.yaml\""
}

test_validate_artifact_empty_collector_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_collector_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: 
    command: ls
    output_directory: /tmp
    output_file: ls.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_collector_fail.yaml\""
}

test_validate_artifact_invalid_collector_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_collector_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: invalid
    command: ls
    output_directory: /tmp
    output_file: ls.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_collector_fail.yaml\""
}

test_validate_artifact_empty_command_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_command_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command:      
    output_directory: /tmp
    output_file: ls.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_command_fail.yaml\""
}

test_validate_artifact_empty_multi_line_command_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_multi_line_command_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: """

    """
    output_directory: /tmp
    output_file: ls.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_multi_line_command_fail.yaml\""
}

test_validate_artifact_missing_closing_multi_line_command_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/missing_closing_multi_line_command_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: """

    
    output_directory: /tmp
    output_file: ls.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/missing_closing_multi_line_command_fail.yaml\""
}

test_validate_artifact_empty_compress_output_file_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_compress_output_file_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt
    compress_output_file:
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_compress_output_file_fail.yaml\""
}

test_validate_artifact_invalid_compress_output_file_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_compress_output_file_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt
    compress_output_file: invalid
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_compress_output_file_fail.yaml\""
}

test_validate_artifact_empty_redirect_stderr_to_stdour_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_redirect_stderr_to_stdour_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt
    compress_output_file: true
    redirect_stderr_to_stdout:
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_redirect_stderr_to_stdour_fail.yaml\""
}

test_validate_artifact_empty_global_condition_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_global_condition_fail.yaml"
version: 1.0
condition: 
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_global_condition_fail.yaml\""
}

test_validate_artifact_empty_local_condition_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_local_condition_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt
    condition: 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_local_condition_fail.yaml\""
}

test_validate_artifact_empty_multi_line_condition_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_multi_line_condition_fail.yaml"
version: 1.0
condition: """
      
    """
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt    
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_multi_line_condition_fail.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_multi_line_condition_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt
    condition: """
      
    """
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_multi_line_condition_fail.yaml\""
}

test_validate_artifact_missing_closing_multi_line_foreach_fail()
{
  is_in_list()
  {
    return 0
  }
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/missing_closing_multi_line_foreach_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    foreach: """
      
    output_file: ls.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/missing_closing_multi_line_foreach_fail.yaml\""
}

test_validate_artifact_empty_description_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_description_fail.yaml"
version: 1.0
artifacts:
  -
    description: 
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_description_fail.yaml\""
}

test_validate_artifact_empty_exclude_file_system_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_exclude_file_system_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_file_system: 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_exclude_file_system_fail.yaml\""
}

test_validate_artifact_empty_array_exclude_file_system_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_array_exclude_file_system_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_file_system: []
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_array_exclude_file_system_fail.yaml\""
}

test_validate_artifact_invalid_array_exclude_file_system_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_array_exclude_file_system_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_file_system: [
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_array_exclude_file_system_fail.yaml\""
}

test_validate_artifact_empty_exclude_name_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_exclude_name_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_name_pattern:
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_exclude_name_pattern_fail.yaml\""
}

test_validate_artifact_empty_array_exclude_name_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_array_exclude_name_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_name_pattern: []
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_array_exclude_name_pattern_fail.yaml\""
}

test_validate_artifact_invalid_array_exclude_name_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_array_exclude_name_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_name_pattern: [
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_array_exclude_name_pattern_fail.yaml\""
}

test_validate_artifact_empty_exclude_nologin_users_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_exclude_nologin_users_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_nologin_users:
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_exclude_nologin_users_fail.yaml\""
}

test_validate_artifact_invalid_exclude_nologin_users_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_exclude_nologin_users_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_nologin_users: invalid
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_exclude_nologin_users_fail.yaml\""
}

test_validate_artifact_empty_exclude_path_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_exclude_path_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_path_pattern:
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_exclude_path_pattern_fail.yaml\""
}

test_validate_artifact_empty_array_exclude_path_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_array_exclude_path_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_path_pattern: []
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_array_exclude_path_pattern_fail.yaml\""
}

test_validate_artifact_invalid_array_exclude_path_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_array_exclude_path_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    exclude_path_pattern: [
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_array_exclude_path_pattern_fail.yaml\""
}

test_validate_artifact_empty_file_type_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_file_type_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    file_type:
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_file_type_fail.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_file_type_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    file_type: []
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_file_type_fail.yaml\""
}

test_validate_artifact_invalid_file_type_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_file_type_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    file_type: [f, s, X]
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_file_type_fail.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_file_type_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    file_type: f
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_file_type_fail.yaml\""

}

test_validate_artifact_empty_foreach_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_foreach_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt
    foreach:    
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_foreach_fail.yaml\""
}

test_validate_artifact_empty_multi_line_foreach_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_multi_line_foreach_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    output_file: ls.txt
    foreach: """
      
    """
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_multi_line_foreach_fail.yaml\""
}

test_validate_artifact_missing_closing_multi_line_foreach_fail()
{
  is_in_list()
  {
    return 0
  }
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/missing_closing_multi_line_foreach_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: command
    command: ls
    output_directory: /tmp
    foreach: """
      

    output_file: test.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/missing_closing_multi_line_foreach_fail.yaml\""
}

test_validate_artifact_empty_ignore_date_range_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_ignore_date_range_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    ignore_date_range: 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_ignore_date_range_fail.yaml\""
}

test_validate_artifact_invalid_ignore_date_range_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_ignore_date_range_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    ignore_date_range: invalid
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_ignore_date_range_fail.yaml\""
}

test_validate_artifact_empty_is_file_list_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_is_file_list_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    is_file_list:
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_is_file_list_fail.yaml\""
}

test_validate_artifact_invalid_is_file_list_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_is_file_list_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    is_file_list: invalid
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_is_file_list_fail.yaml\""
}

test_validate_artifact_empty_max_depth_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_max_depth_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_depth: 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_max_depth_fail.yaml\""
}

test_validate_artifact_negative_max_depth_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/negative_max_depth_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_depth: -10
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/negative_max_depth_fail.yaml\""
}

test_validate_artifact_float_max_depth_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/float_max_depth_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_depth: 1.0
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/float_max_depth_fail.yaml\""
}

test_validate_artifact_invalid_max_depth_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_max_depth_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_depth: invalid
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_max_depth_fail.yaml\""
}

test_validate_artifact_empty_max_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_max_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_file_size: 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_max_file_size_fail.yaml\""
}

test_validate_artifact_zero_max_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/zero_max_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_file_size: 0
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/zero_max_file_size_fail.yaml\""
}

test_validate_artifact_negative_max_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/negative_max_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_file_size: -10
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/negative_max_file_size_fail.yaml\""
}

test_validate_artifact_float_max_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/float_max_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_file_size: 1.0
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/float_max_file_size_fail.yaml\""
}

test_validate_artifact_invalid_max_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_max_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_file_size: invalid
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_max_file_size_fail.yaml\""
}

test_validate_artifact_empty_file_type_max_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_file_type_max_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    max_file_size: 102400
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_file_type_max_file_size_fail.yaml\""
}

test_validate_artifact_invalid_file_type_max_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_file_type_max_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    file_type: [d]
    max_file_size: 102400
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_file_type_max_file_size_fail.yaml\""
}

test_validate_artifact_empty_min_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_min_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    min_file_size: 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_min_file_size_fail.yaml\""
}

test_validate_artifact_zero_min_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/zero_min_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    min_file_size: 0
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/zero_min_file_size_fail.yaml\""
}

test_validate_artifact_negative_min_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/negative_min_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    min_file_size: -10
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/negative_min_file_size_fail.yaml\""
}

test_validate_artifact_float_min_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/float_min_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    min_file_size: 1.0
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/float_min_file_size_fail.yaml\""
}

test_validate_artifact_invalid_min_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_min_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    min_file_size: invalid
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_min_file_size_fail.yaml\""
}

test_validate_artifact_empty_file_type_min_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_file_type_min_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    min_file_size: 102400
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_file_type_min_file_size_fail.yaml\""
}

test_validate_artifact_invalid_file_type_min_file_size_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_file_type_min_file_size_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    file_type: [d]
    min_file_size: 102400
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_file_type_min_file_size_fail.yaml\""
}

test_validate_artifact_empty_modifier_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_modifier_fail.yaml"
version: 1.0
modifier: 
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_modifier_fail.yaml\""
}

test_validate_artifact_invalid_modifier_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_modifier_fail.yaml"
version: 1.0
modifier: invalid
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_modifier_fail.yaml\""
}

test_validate_artifact_empty_name_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_name_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    name_pattern: 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_name_pattern_fail.yaml\""
}

test_validate_artifact_empty_array_name_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_array_name_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    name_pattern: [   ] 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_array_name_pattern_fail.yaml\""
}

test_validate_artifact_invalid_array_name_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_array_name_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    name_pattern: ]
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_array_name_pattern_fail.yaml\""
}

test_validate_artifact_empty_no_group_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_no_group_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    no_group: 
    output_directory: /tmp
    output_file: hash_tmp.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_no_group_fail.yaml\""
}

test_validate_artifact_invalid_no_group_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_no_group_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    no_group: invalid
    output_directory: /tmp
    output_file: hash_tmp.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_no_group_fail.yaml\""
}

test_validate_artifact_empty_no_user_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_no_user_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    no_user: 
    output_directory: /tmp
    output_file: hash_tmp.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_no_user_fail.yaml\""
}

test_validate_artifact_invalid_no_user_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_no_user_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    no_user: invalid
    output_directory: /tmp
    output_file: hash_tmp.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_no_user_fail.yaml\""
}

test_validate_artifact_output_directory_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/output_directory_success.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
EOF

  assertTrue "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/output_directory_success.yaml\""
}

test_validate_artifact_empty_output_directory_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_output_directory_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash_tmp.txt
    output_directory: 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_output_directory_fail.yaml\""
}

test_validate_artifact_relative_output_directory_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/relative_output_directory_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: tmp
    output_file: hash_tmp.txt
EOF

  assertTrue "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/relative_output_directory_fail.yaml\""
}

test_validate_artifact_global_output_directory_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/global_output_directory_success.yaml"
version: 1.0
output_directory: tmp
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash_tmp.txt
EOF

  assertTrue "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/global_output_directory_success.yaml\""
}

test_validate_artifact_empty_global_output_directory_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_global_output_directory_fail.yaml"
version: 1.0
output_directory: 
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash_tmp.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_global_output_directory_fail.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_global_output_directory_fail.yaml"
version: 1.0
output_directory: 
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash_tmp.txt
    output_directory: 
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_global_output_directory_fail.yaml\""
}

test_validate_artifact_empty_output_file_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_output_file_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: 
    output_directory: /tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_output_file_fail.yaml\""
}

test_validate_artifact_path_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/path_success.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
EOF

  assertTrue "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/path_success.yaml\""
}

test_validate_artifact_empty_path_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_path_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: 
    output_file: hash.txt
    output_directory: /tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_path_fail.yaml\""
}

test_validate_artifact_relative_path_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/relative_path_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: tmp
    output_file: hash.txt
    output_directory: /tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/relative_path_fail.yaml\""
}

test_validate_artifact_empty_path_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_path_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
    path_pattern:
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_path_pattern_fail.yaml\""
}

test_validate_artifact_empty_array_path_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_array_path_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
    path_pattern: []
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_array_path_pattern_fail.yaml\""
}

test_validate_artifact_invalid_array_path_pattern_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_array_path_pattern_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
    path_pattern: [
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_array_path_pattern_fail.yaml\""
}

test_validate_artifact_empty_permissions_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_permissions_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    permissions:
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_permissions_fail.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_permissions_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_directory: /tmp
    output_file: hash_tmp.txt
    permissions: []
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_permissions_fail.yaml\""
}

test_validate_artifact_less_than_minus_7777_permissions_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/less_than_minus_7777_permissions_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
    permissions: [4444, -7778]
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/less_than_minus_7777_permissions_fail.yaml\""
}

test_validate_artifact_greater_than_7777_permissions_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/greater_than_7777_permissions_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
    permissions: [7778, 4444]
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/greater_than_7777_permissions_fail.yaml\""
}

test_validate_artifact_empty_supported_os_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_supported_os_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os:
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_supported_os_fail.yaml\""
}

test_validate_artifact_empty_array_supported_os_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_array_supported_os_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [ ]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp

EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_array_supported_os_fail.yaml\""
}

test_validate_artifact_invalid_array_supported_os_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_array_supported_os_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: ]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_array_supported_os_fail.yaml\""
}

test_validate_artifact_no_array_supported_os_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/no_array_supported_os_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: aix,linux
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp

EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/no_array_supported_os_fail.yaml\""
}

test_validate_artifact_invalid_supported_os_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_supported_os_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [ aix, linux, "invalid", solaris ]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
    
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_supported_os_fail.yaml\""
}

test_validate_artifact_empty_version_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/empty_version_fail.yaml"
version: 
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    path: /etc
    output_directory: tmp
    output_file: test.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/empty_version_fail.yaml\""
}

test_validate_artifact_missing_version_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/missing_version_fail.yaml"
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    path: /etc
    output_directory: tmp
    output_file: test.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/missing_version_fail.yaml\""
}

test_validate_artifact_missing_artifacts_mapping_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/missing_artifacts_mapping_fail.yaml"
version: 1.0
  -
    description: example 1
    supported_os: [ aix, linux, solaris ]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/missing_artifacts_mapping_fail.yaml\""
}

test_validate_artifact_missing_description_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/missing_description_property_fail.yaml"
version: 1.0
artifacts:
  -
    supported_os: [ aix, linux, solaris ]
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/missing_description_property_fail.yaml\""
}

test_validate_artifact_missing_supported_os_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/missing_supported_os_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    collector: hash
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/missing_supported_os_property_fail.yaml\""
}

test_validate_artifact_missing_collector_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/missing_collector_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [ aix, linux, solaris ]
    path: /tmp
    output_file: hash.txt
    output_directory: /tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/missing_collector_property_fail.yaml\""
}

test_validate_artifact_command_file_hash_stat_collector_missing_output_directory_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_file_hash_stat_collector_missing_output_directory_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: example 1
    supported_os: [ aix, linux, solaris ]
    collector: find
    path: /tmp
    output_file: hash.txt

EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_file_hash_stat_collector_missing_output_directory_property_fail.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_file_hash_stat_collector_missing_output_directory_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    path: /tmp
    output_file: hash.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_file_hash_stat_collector_missing_output_directory_property_fail.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_file_hash_stat_collector_missing_output_directory_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: stat
    path: /tmp
    output_file: hash.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_file_hash_stat_collector_missing_output_directory_property_fail.yaml\""
}

test_validate_artifact_command_collector_missing_command_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_missing_command_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_missing_command_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_exclude_file_system_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_exclude_file_system_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    exclude_file_system: ["btrfs", "ext4"]
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_exclude_file_system_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_exclude_name_pattern_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_exclude_name_pattern_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    exclude_name_pattern: ["*.sh", "*.txt"]
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_exclude_name_pattern_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_exclude_path_pattern_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_exclude_path_pattern_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    exclude_path_pattern: ["/lib", "/usr"]
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_exclude_path_pattern_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_file_type_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_file_type_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    file_type: [f]
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_file_type_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_ignore_date_range_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_ignore_date_range_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    ignore_date_range: true
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_ignore_date_range_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_is_file_list_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_is_file_list_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    is_file_list: true
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_is_file_list_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_max_depth_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_max_depth_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    max_depth: 5
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_max_depth_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_max_file_size_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_max_file_size_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    max_file_size: 500
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_max_file_size_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_min_file_size_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_min_file_size_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    min_file_size: 500
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_min_file_size_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_modifier_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_modifier_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    modifier: true
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_modifier_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_name_pattern_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_name_pattern_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    name_pattern: ["*.sh", "*.txt"]
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_name_pattern_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_no_group_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_no_group_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    no_group: true
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_no_group_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_no_user_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_no_user_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    no_user: true
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_no_user_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_path_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_path_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    path: /etc
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_path_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_path_pattern_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_path_pattern_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    path_pattern: ["/lib", "/usr"]
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_path_pattern_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_permissions_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_permissions_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    command: ls
    permissions: [4444]
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_permissions_property_fail.yaml\""
}

test_validate_artifact_command_collector_invalid_redirect_stderr_to_stdout_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_redirect_stderr_to_stdout_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    condition: ls /tmp
    foreach: ls /tmp
    command: ls
    output_directory: /tmp
    output_file: test.txt
    compress_output_file: true
    exclude_nologin_users: true
    redirect_stderr_to_stdout: invalid
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_invalid_redirect_stderr_to_stdout_fail.yaml\""
}

test_validate_artifact_hash_collector_missing_path_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/hash_collector_missing_path_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    output_directory: tmp
    output_file: tmp.txt
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/hash_collector_missing_path_property_fail.yaml\""
}

test_validate_artifact_hash_collector_invalid_command_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/hash_collector_invalid_command_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    path: /etc
    command: ls
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/hash_collector_invalid_command_property_fail.yaml\""
}

test_validate_artifact_hash_collector_invalid_compress_output_file_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/hash_collector_invalid_compress_output_file_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    path: /etc
    compress_output_file: true
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/hash_collector_invalid_compress_output_file_property_fail.yaml\""
}

test_validate_artifact_hash_collector_invalid_foreach_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/hash_collector_invalid_foreach_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    path: /etc
    foreach: ls
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/hash_collector_invalid_foreach_property_fail.yaml\""
}

test_validate_artifact_hash_collector_invalid_modifier_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/hash_collector_invalid_modifier_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    path: /etc
    modifier: true
    output_file: test.txt
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/hash_collector_invalid_modifier_property_fail.yaml\""
}

test_validate_artifact_hash_collector_missing_output_file_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/hash_collector_missing_output_file_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    path: /etc
    output_directory: tmp
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/hash_collector_missing_output_file_property_fail.yaml\""
}

test_validate_artifact_hash_collector_redirect_stderr_to_stdout_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/hash_collector_redirect_stderr_to_stdout_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    path: /etc
    output_directory: tmp
    output_file: test.txt
    redirect_stderr_to_stdout: true
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/hash_collector_redirect_stderr_to_stdout_property_fail.yaml\""
}

test_validate_artifact_file_collector_redirect_stderr_to_stdout_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/file_collector_redirect_stderr_to_stdout_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: file
    path: /etc
    redirect_stderr_to_stdout: true
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/file_collector_redirect_stderr_to_stdout_property_fail.yaml\""
}

test_validate_artifact_find_collector_redirect_stderr_to_stdout_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/find_collector_redirect_stderr_to_stdout_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: find
    path: /etc
    output_directory: tmp
    output_file: test.txt
    redirect_stderr_to_stdout: true
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/find_collector_redirect_stderr_to_stdout_property_fail.yaml\""
}

test_validate_artifact_stat_collector_redirect_stderr_to_stdout_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/stat_collector_redirect_stderr_to_stdout_property_fail.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: stat
    path: /etc
    output_directory: tmp
    output_file: test.txt
    redirect_stderr_to_stdout: true
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/stat_collector_redirect_stderr_to_stdout_property_fail.yaml\""
}

test_validate_artifact_invalid_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/invalid_property_fail.yaml"
non-existent-option: test
EOF

  assertFalse "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/invalid_property_fail.yaml\""
}

test_validate_artifact_command_collector_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/command_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: command
    condition: ls /tmp
    foreach: ls /tmp
    command: ls
    output_directory: /tmp
    output_file: test.txt
    compress_output_file: true
    exclude_nologin_users: true
    redirect_stderr_to_stdout: true
EOF

  assertTrue "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/command_collector_success.yaml\""
}

test_validate_artifact_file_collector_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/file_collector_success.yaml"
version: 1.0
modifier: true
artifacts:
  -
    description: test
    supported_os: [all]
    collector: file
    condition: ls /tmp
    exclude_file_system: ["btrfs"]
    exclude_name_pattern: ["*.so"]
    exclude_nologin_users: true
    exclude_path_pattern: ["/usr"]
    file_type: [f]
    ignore_date_range: true
    is_file_list: true
    max_depth: 5
    max_file_size: 1000
    min_file_size: 500
    name_pattern: ["*.txt"]
    no_group: true
    no_user: false
    path: /etc
    path_pattern: ["/etc/default"]
    permissions: [4444]
EOF

  assertTrue "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/file_collector_success.yaml\""
}

test_validate_artifact_find_collector_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/find_collector_success.yaml"
version: 1.0
modifier: false
artifacts:
  -
    description: test
    supported_os: [all]
    collector: find
    condition: ls /tmp
    exclude_file_system: ["btrfs"]
    exclude_name_pattern: ["*.so"]
    exclude_nologin_users: true
    exclude_path_pattern: ["/usr"]
    file_type: [f]
    ignore_date_range: true
    is_file_list: true
    max_depth: 5
    max_file_size: 1000
    min_file_size: 500
    name_pattern: ["*.txt"]
    no_group: true
    no_user: false
    output_directory: /tmp
    output_file: test.txt
    path: /etc
    path_pattern: ["/etc/default"]
    permissions: [4444]
EOF

  assertTrue "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/find_collector_success.yaml\""
}

test_validate_artifact_hash_collector_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/hash_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: hash
    condition: ls /tmp
    exclude_file_system: ["btrfs"]
    exclude_name_pattern: ["*.so"]
    exclude_nologin_users: true
    exclude_path_pattern: ["/usr"]
    file_type: [f]
    ignore_date_range: true
    is_file_list: true
    max_depth: 5
    max_file_size: 1000
    min_file_size: 500
    name_pattern: ["*.txt"]
    no_group: true
    no_user: false
    output_directory: /tmp
    output_file: test.txt
    path: /etc
    path_pattern: ["/etc/default"]
    permissions: [4444]
EOF

  assertTrue "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/hash_collector_success.yaml\""
}

test_validate_artifact_stat_collector_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/stat_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: test
    supported_os: [all]
    collector: stat
    condition: ls /tmp
    exclude_file_system: ["btrfs"]
    exclude_name_pattern: ["*.so"]
    exclude_nologin_users: true
    exclude_path_pattern: ["/usr"]
    file_type: [f]
    ignore_date_range: true
    is_file_list: true
    max_depth: 5
    max_file_size: 1000
    min_file_size: 500
    name_pattern: ["*.txt"]
    no_group: true
    no_user: false
    output_directory: /tmp
    output_file: test.txt
    path: /etc
    path_pattern: ["/etc/default"]
    permissions: [4444]
EOF

  assertTrue "_validate_artifact \"${__TEST_TEMP_DIR}/artifacts/stat_collector_success.yaml\""
}
