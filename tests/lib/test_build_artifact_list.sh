#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/build_artifact_list.sh"

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_build_artifact_list"

  mkdir -p "${__TEST_TEMP_DIR}/artifacts/directory"
  mkdir -p "${__TEST_TEMP_DIR}/tmp/directory"

  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/artifact01.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, linux, freebsd, solaris ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/artifact02.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ aix, freebsd, linux, solaris ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/artifact03.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ linux, solaris ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/artifact04.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ linux ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/directory/artifact05.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF
  cat <<EOF >"${__TEST_TEMP_DIR}/artifacts/directory/artifact06.yaml"
version: 1.0
artifacts:
  -
    description: example
    supported_os: [ all ]
EOF

}

test_build_artifact_list_all_success()
{
  __test_actual=`_build_artifact_list "${__TEST_TEMP_DIR}/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/artifacts/artifact02.yaml
${__TEST_TEMP_DIR}/artifacts/artifact03.yaml
${__TEST_TEMP_DIR}/artifacts/artifact04.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact06.yaml"`
  assertEquals "${__TEST_TEMP_DIR}/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact06.yaml" "${__test_actual}"
}

test_build_artifact_list_linux_only_success()
{
  __test_actual=`_build_artifact_list "${__TEST_TEMP_DIR}/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/artifacts/artifact02.yaml
${__TEST_TEMP_DIR}/artifacts/artifact03.yaml
${__TEST_TEMP_DIR}/artifacts/artifact04.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact06.yaml" "linux"`
  assertEquals "${__TEST_TEMP_DIR}/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/artifacts/artifact02.yaml
${__TEST_TEMP_DIR}/artifacts/artifact03.yaml
${__TEST_TEMP_DIR}/artifacts/artifact04.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact06.yaml" "${__test_actual}"
}

test_build_artifact_list_freebsd_only_success()
{
  __test_actual=`_build_artifact_list "${__TEST_TEMP_DIR}/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/artifacts/artifact02.yaml
${__TEST_TEMP_DIR}/artifacts/artifact03.yaml
${__TEST_TEMP_DIR}/artifacts/artifact04.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact06.yaml" "freebsd"`
  assertEquals "${__TEST_TEMP_DIR}/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/artifacts/artifact02.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact06.yaml" "${__test_actual}"
}

test_build_artifact_list_ignore_operating_system_success()
{
  __UAC_IGNORE_OPERATING_SYSTEM=true

  __test_actual=`_build_artifact_list "${__TEST_TEMP_DIR}/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/artifacts/artifact02.yaml
${__TEST_TEMP_DIR}/artifacts/artifact03.yaml
${__TEST_TEMP_DIR}/artifacts/artifact04.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact06.yaml" "freebsd"`
  assertEquals "${__TEST_TEMP_DIR}/artifacts/artifact01.yaml
${__TEST_TEMP_DIR}/artifacts/artifact02.yaml
${__TEST_TEMP_DIR}/artifacts/artifact03.yaml
${__TEST_TEMP_DIR}/artifacts/artifact04.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact05.yaml
${__TEST_TEMP_DIR}/artifacts/directory/artifact06.yaml" "${__test_actual}"
}
