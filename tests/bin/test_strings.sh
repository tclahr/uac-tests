#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2002,SC2006

oneTimeSetUp()
{
  PATH="${UAC_DIR}/bin:${PATH}"

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_astrings"

  mkdir -p "${__TEST_TEMP_DIR}"

  cat <<EOF > "${__TEST_TEMP_DIR}/file01.bin"
file01 line01
file01 line02
file01 line03
EOF

  cat <<EOF > "${__TEST_TEMP_DIR}/file02.bin"
file02 line01
file02 line02
file02 line03
EOF

}

test_astrings_invalid_arguments_fail()
{
  assertFalse "astrings -n"
  assertFalse "astrings -n a"
}

test_astrings_success()
{
  __test_actual=`astrings "${__TEST_TEMP_DIR}/file01.bin"`
  assertEquals "file01 line01
file01 line02
file01 line03" "${__test_actual}"

  __test_actual=`astrings "${__TEST_TEMP_DIR}/file01.bin" "${__TEST_TEMP_DIR}/file02.bin"`
  assertEquals "file01 line01
file01 line02
file01 line03
file02 line01
file02 line02
file02 line03" "${__test_actual}"

  __test_actual=`cat "${__TEST_TEMP_DIR}/file01.bin" | astrings`
  assertEquals "file01 line01
file01 line02
file01 line03" "${__test_actual}"

}

test_astrings_n_parameter_success()
{
  __test_actual=`astrings -n 8 "${__TEST_TEMP_DIR}/file01.bin"`
  assertEquals "file01 line01
file01 line02
file01 line03" "${__test_actual}"
}

test_astrings_print_file_name_success()
{
  __test_actual=`astrings -f "${__TEST_TEMP_DIR}/file01.bin"`
  assertEquals "${__TEST_TEMP_DIR}/file01.bin: file01 line01
${__TEST_TEMP_DIR}/file01.bin: file01 line02
${__TEST_TEMP_DIR}/file01.bin: file01 line03" "${__test_actual}"

  __test_actual=`astrings -f "${__TEST_TEMP_DIR}/file01.bin" "${__TEST_TEMP_DIR}/file02.bin"`
  assertEquals "${__TEST_TEMP_DIR}/file01.bin: file01 line01
${__TEST_TEMP_DIR}/file01.bin: file01 line02
${__TEST_TEMP_DIR}/file01.bin: file01 line03
${__TEST_TEMP_DIR}/file02.bin: file02 line01
${__TEST_TEMP_DIR}/file02.bin: file02 line02
${__TEST_TEMP_DIR}/file02.bin: file02 line03" "${__test_actual}"
}
