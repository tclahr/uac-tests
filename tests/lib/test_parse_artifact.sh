#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2153,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/parse_artifact.sh"

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

  _log_msg()
  {
    __lm_level="${1:-INF}"
    __lm_message="${2:-}"

    printf %b "YYYYMMDD hh:mm:ss Z ${__lm_level} ${__lm_message}\n" \
      >>"${__TEST_TEMP_DIR}/test.log" \
      2>/dev/null
  }

  _verbose_msg()
  {
    return 0
  }

  _run_command()
  {
    __rc_command=`printf %b "${1}" | awk 'BEGIN {ORS="/n"} {print $0}' | sed -e 's|  *| |g' -e 's|/n$||'`
    _log_msg CMD "${__rc_command}"
    eval "${1:-}"
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

  _command_collector() {
    __cc_foreach="${1:-}"
    __cc_command="${2:-}"
    __cc_output_directory="${3:-}"
    __cc_output_file="${4:-}"
    __cc_compress_output_file="${5:-false}"
    __cc_redirect_stderr_to_stdout="${6:-false}"

    printf %b "_command_collector \"${__cc_foreach}\" \"${__cc_command}\" \"${__cc_output_directory}\" \"${__cc_output_file}\" ${__cc_compress_output_file} ${__cc_redirect_stderr_to_stdout}\n"
    _log_msg CMD "_command_collector \"${__cc_foreach}\" \"${__cc_command}\" \"${__cc_output_directory}\" \"${__cc_output_file}\" ${__cc_compress_output_file} ${__cc_redirect_stderr_to_stdout}"
  }

  _find_based_collector() {
    __fc_collector="${1:-}"
    shift
    __fc_path="${1:-}"
    shift
    __fc_is_file_list="${1:-}"
    shift
    __fc_path_pattern="${1:-}"
    shift
    __fc_name_pattern="${1:-}"
    shift
    __fc_exclude_path_pattern="${1:-}"
    shift
    __fc_exclude_name_pattern="${1:-}"
    shift
    __fc_exclude_file_system="${1:-}"
    shift
    __fc_max_depth="${1:-}"
    shift
    __fc_file_type="${1:-}"
    shift
    __fc_min_file_size="${1:-}"
    shift
    __fc_max_file_size="${1:-}"
    shift
    __fc_permissions="${1:-}"
    shift
    __fc_ignore_date_range="${1:-false}"
    shift
    __fc_output_directory="${1:-}"
    shift
    __fc_output_file="${1:-}"

    printf %b "_find_based_collector \"${__fc_collector}\" \"${__fc_path}\" \"${__fc_is_file_list}\" \"${__fc_path_pattern}\" \"${__fc_name_pattern}\" \"${__fc_exclude_path_pattern}\" \"${__fc_exclude_name_pattern}\" \"${__fc_exclude_file_system}\" \"${__fc_max_depth}\" \"${__fc_file_type}\" \"${__fc_min_file_size}\" \"${__fc_max_file_size}\" \"${__fc_permissions}\" ${__fc_ignore_date_range} \"${__fc_output_directory}\" \"${__fc_output_file}\"\n"
    _log_msg CMD "_find_based_collector \"${__fc_collector}\" \"${__fc_path}\" \"${__fc_is_file_list}\" \"${__fc_path_pattern}\" \"${__fc_name_pattern}\" \"${__fc_exclude_path_pattern}\" \"${__fc_exclude_name_pattern}\" \"${__fc_exclude_file_system}\" \"${__fc_max_depth}\" \"${__fc_file_type}\" \"${__fc_min_file_size}\" \"${__fc_max_file_size}\" \"${__fc_permissions}\" ${__fc_ignore_date_range} \"${__fc_output_directory}\" \"${__fc_output_file}\""
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_parse_artifact"

  mkdir -p "${__TEST_TEMP_DIR}/mount-point"
  mkdir -p "${__TEST_TEMP_DIR}/uac/artifacts/"

  __UAC_DIR="${__TEST_TEMP_DIR}/uac"
  __UAC_TEMP_DATA_DIR="${__TEST_TEMP_DIR}"

}

setUp()
{
  __UAC_MOUNT_POINT="${__TEST_TEMP_DIR}/mount-point"
  __UAC_OPERATING_SYSTEM="linux"
  __UAC_START_DATE=""
  __UAC_END_DATE=""
  __UAC_START_DATE_EPOCH=""
  __UAC_END_DATE_EPOCH=""
  __UAC_USER_HOME_LIST=""
  __UAC_VALID_SHELL_ONLY_USER_HOME_LIST=""
  __UAC_VERBOSE_CMD_PREFIX=" > "
  __UAC_DEBUG_MODE=true
}

test_parse_artifact_invalid_artifact_fail()
{
  assertFalse "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/invalid_artifact_fail.yaml\""
}

test_parse_artifact_artifacts_prop_mappings_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/artifacts_prop_mappings_fail.yaml"
version: 1.0
artifacts:
  description: example
EOF

  assertFalse "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/artifacts_prop_mappings_fail.yaml\""
}

test_parse_artifact_artifacts_supported_os_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/supported_os_fail.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, macos, solaris ]
    collector: command
    command: ls ${__TEST_TEMP_DIR}/uac/artifacts/supported_os_fail.yaml
    output_directory: supported_os_fail
    output_file: supported_os_fail.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/supported_os_fail.yaml"`
  assertNotEquals "_command_collector \"\" \"ls ${__TEST_TEMP_DIR}/uac/artifacts/supported_os_fail.yaml\" \"${__UAC_TEMP_DATA_DIR}/collected/supported_os_fail\" \"supported_os_fail.txt\" false false" "${__test_actual}"
}

test_parse_artifact_artifacts_ignore_operating_system_true_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/debug_mode_true_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, macos, solaris ]
    collector: command
    command: ls ${__TEST_TEMP_DIR}/uac/artifacts/debug_mode_true_success.yaml
    output_directory: debug_mode_true_success
    output_file: debug_mode_true_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/supported_os_fail.yaml"`
  assertNotEquals "_command_collector \"\" \"ls ${__TEST_TEMP_DIR}/uac/artifacts/supported_os_fail.yaml\" \"${__UAC_TEMP_DATA_DIR}/collected/supported_os_fail\" \"supported_os_fail.txt\" false false" "${__test_actual}"

  __UAC_IGNORE_OPERATING_SYSTEM=true
  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/supported_os_fail.yaml"`
  assertEquals "_command_collector \"\" \"ls ${__TEST_TEMP_DIR}/uac/artifacts/supported_os_fail.yaml\" \"${__UAC_TEMP_DATA_DIR}/collected/supported_os_fail\" \"supported_os_fail.txt\" false false" "${__test_actual}"
}

test_parse_artifact_artifacts_invalid_collector_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/invalid_collector_fail.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: invalid
    command: ls "${__TEST_TEMP_DIR}/uac/artifacts/invalid_collector_fail.yaml"
    output_directory: invalid_collector_fail
    output_file: invalid_collector_fail.txt
EOF

  assertFail "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/invalid_collector_fail.yaml\""  
}

test_parse_artifact_artifacts_global_condition_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml"
version: 1.0
condition: ls "${__TEST_TEMP_DIR}" | awk '{print \$0}'
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  command: ls
  output_directory: global_condition_success
  output_file: global_condition_success.txt
EOF

  assertTrue "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml"
version: 1.0
condition: """
  ls "${__TEST_TEMP_DIR}" \
    | awk '{print \$0}'
  """
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  command: ls
  output_directory: global_condition_success
  output_file: global_condition_success.txt
EOF

  assertTrue "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml"
version: 1.0
condition: !ls "${__TEST_TEMP_DIR}/uac/artifacts/invalid_artifact_fail.yaml"
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  command: ls
  output_directory: global_condition_success
  output_file: global_condition_success.txt
EOF

  assertTrue "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml"
version: 1.0
condition: """
  !ls "${__TEST_TEMP_DIR}/uac/artifacts/invalid_artifact_fail.yaml"
  """
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  command: ls
  output_directory: global_condition_success
  output_file: global_condition_success.txt
EOF

  assertTrue "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml"
version: 1.0
condition: ! ls "${__TEST_TEMP_DIR}/uac/artifacts/invalid_artifact_fail.yaml"
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  command: ls
  output_directory: global_condition_success
  output_file: global_condition_success.txt
EOF

  assertTrue "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_success.yaml\""
}

test_parse_artifact_artifacts_global_condition_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_fail.yaml"
version: 1.0
condition: ls "${__TEST_TEMP_DIR}/uac/artifacts/invalid_artifact_fail.yaml"
artifacts:
  -
  description: example
EOF

  assertFalse "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_fail.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_fail.yaml"
version: 1.0
condition: !ls "${__TEST_TEMP_DIR}/uac/artifacts/global_condition_fail.yaml"
artifacts:
  -
  description: example
EOF

  assertFalse "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_fail.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_fail.yaml"
version: 1.0
condition: ! ls "${__TEST_TEMP_DIR}/uac/artifacts/global_condition_fail.yaml"
artifacts:
  -
  description: example
EOF

  assertFalse "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/global_condition_fail.yaml\""
}

test_parse_artifact_command_collector_single_command_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/command_collector_single_command_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    command: ps -ef
    output_directory: command_collector_single_command_success
    output_file: command_collector_single_command_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/command_collector_single_command_success.yaml"`
  assertEquals "_command_collector \"\" \"ps -ef\" \"${__UAC_TEMP_DATA_DIR}/collected/command_collector_single_command_success\" \"command_collector_single_command_success.txt\" false false" "${__test_actual}"
}


test_parse_artifact_command_collector_multiple_commands_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/command_collector_multiple_command_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    command: """
      ps -ef
      ls -la
      lsof
      """
    output_directory: command_collector_multiple_command_success
    output_file: command_collector_multiple_command_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/command_collector_multiple_command_success.yaml"`
  assertEquals "_command_collector \"\" \"ps -ef
ls -la
lsof\" \"${__UAC_TEMP_DATA_DIR}/collected/command_collector_multiple_command_success\" \"command_collector_multiple_command_success.txt\" false false" "${__test_actual}"
}

test_parse_artifact_replace_exposed_variables_success()
{
  __UAC_START_DATE="2023-01-01"
  __UAC_START_DATE_EPOCH="1672531200"
  __UAC_END_DATE="2023-01-31"
  __UAC_END_DATE_EPOCH="1675123200"
 
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/replace_exposed_variables_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    command: ls -la %start_date% %start_date_epoch% %end_date% %end_date_epoch% %mount_point% %temp_directory% %uac_directory%
    output_directory: replace_exposed_variables_success
    output_file: replace_exposed_variables_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/replace_exposed_variables_success.yaml"`
  assertEquals "_command_collector \"\" \"ls -la 2023-01-01 1672531200 2023-01-31 1675123200 ${__UAC_MOUNT_POINT} ${__TEST_TEMP_DIR}/tmp ${__TEST_TEMP_DIR}/uac\" \"${__UAC_TEMP_DATA_DIR}/collected/replace_exposed_variables_success\" \"replace_exposed_variables_success.txt\" false false" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/replace_exposed_variables_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    command: """
      ls -la %start_date% %start_date_epoch% %end_date% %end_date_epoch% %mount_point% %temp_directory% %uac_directory%
      cat /dev/null
      """
    output_directory: replace_exposed_variables_success
    output_file: replace_exposed_variables_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/replace_exposed_variables_success.yaml"`
  assertEquals "_command_collector \"\" \"ls -la 2023-01-01 1672531200 2023-01-31 1675123200 ${__UAC_MOUNT_POINT} ${__TEST_TEMP_DIR}/tmp ${__TEST_TEMP_DIR}/uac
cat /dev/null\" \"${__UAC_TEMP_DATA_DIR}/collected/replace_exposed_variables_success\" \"replace_exposed_variables_success.txt\" false false" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/replace_exposed_variables_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    foreach: ls -la %start_date% %start_date_epoch% %end_date% %end_date_epoch% %mount_point% %temp_directory% %uac_directory%
    command: ls -la
    output_directory: replace_exposed_variables_success
    output_file: replace_exposed_variables_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/replace_exposed_variables_success.yaml"`
  assertEquals "_command_collector \"ls -la 2023-01-01 1672531200 2023-01-31 1675123200 ${__UAC_MOUNT_POINT} ${__TEST_TEMP_DIR}/tmp ${__TEST_TEMP_DIR}/uac\" \"ls -la\" \"${__UAC_TEMP_DATA_DIR}/collected/replace_exposed_variables_success\" \"replace_exposed_variables_success.txt\" false false" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/replace_exposed_variables_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    foreach: """
      ls -la %start_date% %start_date_epoch% %end_date% %end_date_epoch% %mount_point% %temp_directory% %uac_directory%
      cat /dev/null
      """
    command: ls -la
    output_directory: replace_exposed_variables_success
    output_file: replace_exposed_variables_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/replace_exposed_variables_success.yaml"`
  assertEquals "_command_collector \"ls -la 2023-01-01 1672531200 2023-01-31 1675123200 ${__UAC_MOUNT_POINT} ${__TEST_TEMP_DIR}/tmp ${__TEST_TEMP_DIR}/uac
cat /dev/null\" \"ls -la\" \"${__UAC_TEMP_DATA_DIR}/collected/replace_exposed_variables_success\" \"replace_exposed_variables_success.txt\" false false" "${__test_actual}"
}

test_parse_artifact_command_collector_compress_output_file_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/command_collector_compress_output_file_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    command: ls -la
    output_directory: command_collector_compress_output_file_success
    output_file: command_collector_compress_output_file_success.txt
    compress_output_file: true
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/command_collector_compress_output_file_success.yaml"`
  assertEquals "_command_collector \"\" \"ls -la\" \"${__UAC_TEMP_DATA_DIR}/collected/command_collector_compress_output_file_success\" \"command_collector_compress_output_file_success.txt\" true false" "${__test_actual}"
}

test_parse_artifact_command_collector_absolute_output_directory_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/command_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    command: ps -ef
    output_directory: /command_collector_success
    output_file: command_collector_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/command_collector_success.yaml"`
  assertEquals "_command_collector \"\" \"ps -ef\" \"${__UAC_TEMP_DATA_DIR}/collected//command_collector_success\" \"command_collector_success.txt\" false false" "${__test_actual}"
}

test_parse_artifact_command_collector_temp_directory_output_directory_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/command_collector_temp_directory_output_directory_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    command: ps -ef
    output_directory: /%temp_directory%/command_collector_temp_directory_output_directory_success
    output_file: command_collector_temp_directory_output_directory_success.txt

EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/command_collector_temp_directory_output_directory_success.yaml"`
  assertEquals "_command_collector \"\" \"ps -ef\" \"/${__TEST_TEMP_DIR}/tmp/command_collector_temp_directory_output_directory_success\" \"command_collector_temp_directory_output_directory_success.txt\" false false" "${__test_actual}"
}

test_parse_artifact_command_collector_empty_output_file_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/command_collector_empty_output_file_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: command
    command: ps -ef
    output_directory: command_collector_empty_output_file_success



EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/command_collector_empty_output_file_success.yaml"`
  assertEquals "_command_collector \"\" \"ps -ef\" \"${__UAC_TEMP_DATA_DIR}/collected/command_collector_empty_output_file_success\" \"\" false false" "${__test_actual}"
}

test_parse_artifact_artifacts_local_condition_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/local_condition_success.yaml"
version: 1.0
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  condition: ls "${__TEST_TEMP_DIR}" | awk '{print \$0}'
  command: ls
  output_directory: local_condition_success
  output_file: local_condition_success.txt
EOF

  assertTrue "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/local_condition_success.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/local_condition_success.yaml"
version: 1.0
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  condition: !ls "${__TEST_TEMP_DIR}/uac/artifacts/invalid_artifact_fail.yaml"
  command: ls
  output_directory: local_condition_success
  output_file: local_condition_success.txt
EOF

  assertTrue "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/local_condition_success.yaml\""

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/local_condition_success.yaml"
version: 1.0
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  condition: ! ls "${__TEST_TEMP_DIR}/uac/artifacts/invalid_artifact_fail.yaml"
  command: ls
  output_directory: local_condition_success
  output_file: local_condition_success.txt
EOF

  assertTrue "_parse_artifact \"${__TEST_TEMP_DIR}/uac/artifacts/local_condition_success.yaml\""
}

test_parse_artifact_artifacts_user_home_success()
{
  __UAC_USER_HOME_LIST="uac:/home/uac
john:/home/john
daenerys:/home/daenerys"

  __UAC_VALID_SHELL_ONLY_USER_HOME_LIST="uac:/home/uac
john:/home/john"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"
version: 1.0
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  command: ls %user% /%user_home%
  output_directory: /%user_home%_%user%
  output_file: /%user_home%_%user%.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"`
  assertEquals "_command_collector \"\" \"ls uac /home/uac\" \"${__UAC_TEMP_DATA_DIR}/collected//home/uac_uac\" \"/home/uac_uac.txt\" false false
_command_collector \"\" \"ls john /home/john\" \"${__UAC_TEMP_DATA_DIR}/collected//home/john_john\" \"/home/john_john.txt\" false false
_command_collector \"\" \"ls daenerys /home/daenerys\" \"${__UAC_TEMP_DATA_DIR}/collected//home/daenerys_daenerys\" \"/home/daenerys_daenerys.txt\" false false" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"
version: 1.0
artifacts:
  -
  description: example
  supported_os: [all]
  collector: command
  command: ls %user% /%user_home%
  output_directory: /%user_home%_%user%
  output_file: /%user_home%_%user%.txt
  exclude_nologin_users: true
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"`
  assertEquals "_command_collector \"\" \"ls uac /home/uac\" \"${__UAC_TEMP_DATA_DIR}/collected//home/uac_uac\" \"/home/uac_uac.txt\" false false
_command_collector \"\" \"ls john /home/john\" \"${__UAC_TEMP_DATA_DIR}/collected//home/john_john\" \"/home/john_john.txt\" false false" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: find
    path: /%user_home%
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f, d]
    min_file_size: 200
    max_file_size: 500
    permissions: [755, 444]
    ignore_date_range: true
    output_directory: /%user_home%_%user%
    output_file: /%user_home%_%user%.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"`
  assertEquals "_find_based_collector \"find\" \"/home/uac\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f|d\" \"200\" \"500\" \"755|444\" true \"${__UAC_TEMP_DATA_DIR}/collected//home/uac_uac\" \"/home/uac_uac.txt\"
_find_based_collector \"find\" \"/home/john\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f|d\" \"200\" \"500\" \"755|444\" true \"${__UAC_TEMP_DATA_DIR}/collected//home/john_john\" \"/home/john_john.txt\"
_find_based_collector \"find\" \"/home/daenerys\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f|d\" \"200\" \"500\" \"755|444\" true \"${__UAC_TEMP_DATA_DIR}/collected//home/daenerys_daenerys\" \"/home/daenerys_daenerys.txt\"" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: find
    path: /%user_home%
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f]
    min_file_size: 200
    max_file_size: 500
    permissions: [755]
    ignore_date_range: true
    output_directory: /%user_home%_%user%
    output_file: /%user_home%_%user%.txt
    exclude_nologin_users: true
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"`
  assertEquals "_find_based_collector \"find\" \"/home/uac\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__UAC_TEMP_DATA_DIR}/collected//home/uac_uac\" \"/home/uac_uac.txt\"
_find_based_collector \"find\" \"/home/john\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__UAC_TEMP_DATA_DIR}/collected//home/john_john\" \"/home/john_john.txt\"" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: find
    path: %user_home%
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f]
    min_file_size: 200
    max_file_size: 500
    permissions: [755]
    ignore_date_range: true
    output_directory: %user_home%_%user%
    output_file: %user_home%_%user%.txt
    exclude_nologin_users: true
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/user_home_success.yaml"`
  assertEquals "_find_based_collector \"find\" \"home/uac\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__UAC_TEMP_DATA_DIR}/collected/home/uac_uac\" \"home/uac_uac.txt\"
_find_based_collector \"find\" \"home/john\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__UAC_TEMP_DATA_DIR}/collected/home/john_john\" \"home/john_john.txt\"" "${__test_actual}"
  

}

test_parse_artifact_find_based_collector_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/find_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: find
    path: /usr/lib
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f, s, d]
    min_file_size: 200
    max_file_size: 500
    permissions: [755, 644, 444]
    ignore_date_range: true
    output_directory: find_collector_success
    output_file: find_collector_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/find_collector_success.yaml"`
  assertEquals "_find_based_collector \"find\" \"/usr/lib\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f|s|d\" \"200\" \"500\" \"755|644|444\" true \"${__UAC_TEMP_DATA_DIR}/collected/find_collector_success\" \"find_collector_success.txt\"" "${__test_actual}"
}

test_parse_artifact_file_collector_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/file_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: file
    path: /usr/lib
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f]
    min_file_size: 200
    max_file_size: 500
    permissions: [755]
    ignore_date_range: true
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/file_collector_success.yaml"`
  assertEquals "_find_based_collector \"file\" \"/usr/lib\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__TEST_TEMP_DIR}\" \"file_collector.tmp\"" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/file_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: file
    is_file_list: true
    path: /tmp/file_list.txt
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f]
    min_file_size: 200
    max_file_size: 500
    permissions: [755]
    ignore_date_range: true
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/file_collector_success.yaml"`
  assertEquals "_find_based_collector \"file\" \"/tmp/file_list.txt\" \"true\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__TEST_TEMP_DIR}\" \"file_collector.tmp\"" "${__test_actual}"
}

test_parse_artifact_file_collector_skip_collected_home_success()
{
  __UAC_USER_HOME_LIST="uac:/home/uac
john:/home/john
ftp:/
daenerys:/home/daenerys
ssh:/
john2:/home/john"
  __UAC_MOUNT_POINT="/"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/file_collector_skip_collected_home_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: file
    path: /%user_home%
    max_depth: 5
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/file_collector_skip_collected_home_success.yaml"`
  assertEquals "_find_based_collector \"file\" \"/home/uac\" \"false\" \"\" \"\" \"\" \"\" \"\" \"5\" \"\" \"\" \"\" \"\" false \"${__TEST_TEMP_DIR}\" \"file_collector.tmp\"
_find_based_collector \"file\" \"/home/john\" \"false\" \"\" \"\" \"\" \"\" \"\" \"5\" \"\" \"\" \"\" \"\" false \"${__TEST_TEMP_DIR}\" \"file_collector.tmp\"
_find_based_collector \"file\" \"/\" \"false\" \"\" \"\" \"\" \"\" \"\" \"2\" \"\" \"\" \"\" \"\" false \"${__TEST_TEMP_DIR}\" \"file_collector.tmp\"
_find_based_collector \"file\" \"/home/daenerys\" \"false\" \"\" \"\" \"\" \"\" \"\" \"5\" \"\" \"\" \"\" \"\" false \"${__TEST_TEMP_DIR}\" \"file_collector.tmp\"" "${__test_actual}"

}

test_parse_artifact_hash_collector_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/hash_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: hash
    path: /usr/lib
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f]
    min_file_size: 200
    max_file_size: 500
    permissions: [755]
    ignore_date_range: true
    output_directory: hash_collector_success
    output_file: hash_collector_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/hash_collector_success.yaml"`
  assertEquals "_find_based_collector \"hash\" \"/usr/lib\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__UAC_TEMP_DATA_DIR}/collected/hash_collector_success\" \"hash_collector_success.txt\"" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/hash_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: hash
    is_file_list: true
    path: /tmp/file_list.txt
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f]
    min_file_size: 200
    max_file_size: 500
    permissions: [755]
    ignore_date_range: true
    output_directory: hash_collector_success
    output_file: hash_collector_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/hash_collector_success.yaml"`
  assertEquals "_find_based_collector \"hash\" \"/tmp/file_list.txt\" \"true\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__UAC_TEMP_DATA_DIR}/collected/hash_collector_success\" \"hash_collector_success.txt\"" "${__test_actual}"
}

test_parse_artifact_stat_collector_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/stat_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: stat
    path: /usr/lib
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f]
    min_file_size: 200
    max_file_size: 500
    permissions: [755]
    ignore_date_range: true
    output_directory: stat_collector_success
    output_file: stat_collector_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/stat_collector_success.yaml"`
  assertEquals "_find_based_collector \"stat\" \"/usr/lib\" \"false\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__UAC_TEMP_DATA_DIR}/collected/stat_collector_success\" \"stat_collector_success.txt\"" "${__test_actual}"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/stat_collector_success.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, macos, solaris ]
    collector: stat
    is_file_list: true
    path: /tmp/file_list.txt
    path_pattern: ['/usr/local','/etc']
    name_pattern: ['*.so', '*.txt']
    exclude_path_pattern: ['/run', '/proc']
    exclude_name_pattern: ['*.sh']
    exclude_file_system: ['ntfs', 'ext4', 'btrfs']
    max_depth: 5
    file_type: [f]
    min_file_size: 200
    max_file_size: 500
    permissions: [755]
    ignore_date_range: true
    output_directory: stat_collector_success
    output_file: stat_collector_success.txt
EOF

  __test_actual=`_parse_artifact "${__TEST_TEMP_DIR}/uac/artifacts/stat_collector_success.yaml"`
  assertEquals "_find_based_collector \"stat\" \"/tmp/file_list.txt\" \"true\" \"/usr/local|/etc\" \"*.so|*.txt\" \"/run|/proc\" \"*.sh\" \"ntfs|ext4|btrfs\" \"5\" \"f\" \"200\" \"500\" \"755\" true \"${__UAC_TEMP_DATA_DIR}/collected/stat_collector_success\" \"stat_collector_success.txt\"" "${__test_actual}"
}
