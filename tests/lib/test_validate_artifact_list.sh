#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2153,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/validate_artifact_list.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  _filter_list()
  {
    __fl_list="${1:-}"
    __fl_exclude_list="${2:-}"

    __fl_OIFS="${IFS}"
    IFS="
  "
    for __fl_i in ${__fl_list}; do
      __fl_found=false
      for __fl_e in ${__fl_exclude_list}; do
        if [ "${__fl_i}" = "${__fl_e}" ]; then
          __fl_found=true
          break
        fi
      done
      if $__fl_found; then
        true
      else
        printf %b "${__fl_i}\n"
      fi
    done

    IFS="${__fl_OIFS}"
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_validate_artifact_list"

  mkdir -p "${__TEST_TEMP_DIR}/uac/artifacts/directory"
  mkdir -p "${__TEST_TEMP_DIR}/tmp/directory"
  
  __UAC_DIR="${__TEST_TEMP_DIR}/uac"

  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/artifact01.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/artifact02.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/artifact03.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ linux ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/artifact04.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ linux ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/directory/artifact05.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/uac/artifacts/directory/artifact06.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ solaris ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/tmp/artifact07.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/tmp/artifact08.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/tmp/directory/artifact10.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/tmp/directory/artifact11.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF
cat <<EOF >"${__TEST_TEMP_DIR}/tmp/directory/artifact12.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF

}

test_validate_artifact_list_relative_path_success()
{
  assertTrue "_validate_artifact_list \"artifact01.yaml,directory/artifact05.yaml\""
  assertTrue "_validate_artifact_list \"artifact01.yaml,directory/artifact05.yaml,./artifacts/artifact02.yaml\""
  assertTrue "_validate_artifact_list \"artifact01.yaml,directory/artifact05.yaml,./artifacts/artifact02.yaml,artifacts/artifact03.yaml\""

  __test_actual=`_validate_artifact_list "artifact01.yaml,directory/artifact05.yaml,./artifacts/artifact02.yaml,artifacts/artifact03.yaml"`
  assertEquals "${__TEST_TEMP_DIR}/uac/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/uac/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/uac/artifacts/artifact02.yaml
${__TEST_TEMP_DIR}/uac/artifacts/artifact03.yaml" "${__test_actual}"
}

test_validate_artifact_list_relative_path_exclude_success()
{
  assertTrue "_validate_artifact_list \"artifact01.yaml,directory/artifact05.yaml,!directory/artifact05.yaml\""
  assertTrue "_validate_artifact_list \"artifact01.yaml,directory/artifact05.yaml,./artifacts/artifact02.yaml,!directory/artifact05.yaml\""
  assertTrue "_validate_artifact_list \"artifact01.yaml,directory/artifact05.yaml,./artifacts/artifact02.yaml,artifacts/artifact03.yaml,!directory/artifact05.yaml\""

  __test_actual=`_validate_artifact_list "artifact01.yaml,directory/artifact05.yaml,./artifacts/artifact02.yaml,artifacts/artifact03.yaml,!directory/artifact05.yaml"`
  assertEquals "${__TEST_TEMP_DIR}/uac/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/uac/artifacts/artifact02.yaml
${__TEST_TEMP_DIR}/uac/artifacts/artifact03.yaml" "${__test_actual}"
}

test_validate_artifact_list_relative_path_no_such_file_fail()
{
  assertFalse "_validate_artifact_list \"artifact01.yaml,directory/artifact100.yaml\""
  assertFalse "_validate_artifact_list \"artifact01.yaml,directory/artifact05.yaml,./artifacts/artifact100.yaml\""
  assertFalse "_validate_artifact_list \"artifact01.yaml,directory/artifact05.yaml,./artifacts/artifact02.yaml,artifacts/artifact100.yaml\""
}

test_validate_artifact_list_relative_path_dot_dot_fail()
{
  assertFalse "_validate_artifact_list \"../../../../my_custom_dir/artifact01.yaml\""
}

test_validate_artifact_list_relative_path_dedup_success()
{
  __test_actual=`_validate_artifact_list "artifact01.yaml,directory/artifact05.yaml,./artifacts/artifact02.yaml,artifacts/artifact01.yaml"`
  assertEquals "${__TEST_TEMP_DIR}/uac/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/uac/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/uac/artifacts/artifact02.yaml" "${__test_actual}"
}

test_validate_artifact_list_absolute_path_success()
{
  assertTrue "_validate_artifact_list \"${__TEST_TEMP_DIR}/tmp/artifact07.yaml,${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml\""
  
  __test_actual=`_validate_artifact_list "${__TEST_TEMP_DIR}/tmp/artifact07.yaml,${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml"`
  assertEquals "${__TEST_TEMP_DIR}/tmp/artifact07.yaml
${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml" "${__test_actual}"
}

test_validate_artifact_list_absolute_path_exclude_success()
{
  assertTrue "_validate_artifact_list \"${__TEST_TEMP_DIR}/tmp/artifact07.yaml,${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml,!${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml\""
  
  __test_actual=`_validate_artifact_list "${__TEST_TEMP_DIR}/tmp/artifact07.yaml,${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml,!${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml"`
  assertEquals "${__TEST_TEMP_DIR}/tmp/artifact07.yaml" "${__test_actual}"
}

test_validate_artifact_list_absolute_path_no_such_file_fail()
{
  assertFalse "_validate_artifact_list \"${__TEST_TEMP_DIR}/tmp/artifact07.yaml,${__TEST_TEMP_DIR}/tmp/directory/artifact100.yaml\""
}

test_validate_artifact_list_absolute_path_dedup_success()
{
  __test_actual=`_validate_artifact_list "${__TEST_TEMP_DIR}/tmp/artifact07.yaml,${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml,${__TEST_TEMP_DIR}/tmp/artifact07.yaml"`
  assertEquals "${__TEST_TEMP_DIR}/tmp/artifact07.yaml
${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml" "${__test_actual}"
}
