#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/validate_profile.sh"

  _error_msg()
  {
    printf %b "${1}\n" >&2
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_validate_profile"

  mkdir -p "${__TEST_TEMP_DIR}/uac/artifacts/directory"
  mkdir -p "${__TEST_TEMP_DIR}/tmp/directory"
  touch "${__TEST_TEMP_DIR}/uac/artifacts/artifact01.yaml"
  touch "${__TEST_TEMP_DIR}/uac/artifacts/artifact02.yaml"
  touch "${__TEST_TEMP_DIR}/uac/artifacts/directory/artifact03.yaml"
  touch "${__TEST_TEMP_DIR}/uac/artifacts/directory/artifact04.yaml"
  touch "${__TEST_TEMP_DIR}/tmp/artifact05.yaml"
  touch "${__TEST_TEMP_DIR}/tmp/artifact06.yaml"
  touch "${__TEST_TEMP_DIR}/tmp/artifact07.yaml"
  touch "${__TEST_TEMP_DIR}/tmp/directory/artifact08.yaml"
  touch "${__TEST_TEMP_DIR}/tmp/directory/artifact09.yaml"
}

test_validate_profile_invalid_profile_fail()
{
  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/invalid_profile_fail.yaml\""
}

test_validate_profile_duplicate_artifacts_prop_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/duplicate_artifacts_prop_fail.yaml"
artifacts:
  - artifact01.yaml
artifacts:
  - artifact02.yaml
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/duplicate_artifacts_prop_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_empty_description_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/empty_description_fail.yaml"
description:
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/empty_description_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_empty_name_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/empty_name_fail.yaml"
name:
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/empty_description_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_empty_artifact_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/empty_artifact_fail.yaml"
name: test
description: test profile
artifacts:
  -
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/empty_artifact_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_exclamation_mark_only_artifact_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/exclamation_mark_only_artifact_fail.yaml"
name: test
description: test profile
artifacts:
  - !
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/exclamation_mark_only_artifact_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_non_existent_artifact_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/non_existent_artifact_fail.yaml"
name: test
description: test profile
artifacts:
  - test00.yaml
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/non_existent_artifact_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_non_existent_star_artifact_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/non_existent_star_artifact_fail.yaml"
name: test
description: test profile
artifacts:
  - artifact01.yaml
  - invalid/*
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/non_existent_star_artifact_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_non_existent_exclamation_mark_artifact_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/non_existent_exclamation_mark_artifact_fail.yaml"
name: test
description: test profile
artifacts:
  - !test00.yaml
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/non_existent_exclamation_mark_artifact_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_non_existent_star_exclamation_mark_artifact_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/non_existent_star_exclamation_mark_artifact_fail.yaml"
name: test
description: test profile
artifacts:
  - artifact01.yaml
  - !invalid/*
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/non_existent_star_exclamation_mark_artifact_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_valid_single_artifact_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/valid_single_artifact_success.yaml"
name: test
description: test profile
artifacts:
  - artifact01.yaml
EOF

  assertTrue "_validate_profile \"${__TEST_TEMP_DIR}/valid_single_artifact_success.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_valid_single_absolute_path_artifact_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/valid_single_absolute_path_artifact_success.yaml"
name: test
description: test profile
artifacts:
  - ${__TEST_TEMP_DIR}/tmp/artifact05.yaml
EOF

  assertTrue "_validate_profile \"${__TEST_TEMP_DIR}/valid_single_absolute_path_artifact_success.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_valid_single_exclamation_mark_artifact_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/valid_single_exclamation_mark_artifact_success.yaml"
name: test
description: test profile
artifacts:
  - !artifact01.yaml
EOF

  assertTrue "_validate_profile \"${__TEST_TEMP_DIR}/valid_single_exclamation_mark_artifact_success.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_valid_single_absolute_path_exclamation_mark_artifact_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/valid_single_absolute_path_exclamation_mark_artifact_success.yaml"
name: test
description: test profile
artifacts:
  - !${__TEST_TEMP_DIR}/tmp/artifact05.yaml
EOF

  assertTrue "_validate_profile \"${__TEST_TEMP_DIR}/valid_single_absolute_path_exclamation_mark_artifact_success.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_valid_multiple_artifact_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/valid_multiple_artifact_success.yaml"
name: test
description: test profile
artifacts:
  - artifact01.yaml
  - artifact02.yaml
  - directory/artifact03.yaml
  - directory/artifact04.yaml
EOF

  assertTrue "_validate_profile \"${__TEST_TEMP_DIR}/valid_multiple_artifact_success.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_valid_multiple_exclamation_mark_artifact_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/valid_multiple_exclamation_mark_artifact_success.yaml"
name: test
description: test profile
artifacts:
  - artifact01.yaml
  - !artifact02.yaml
  - !directory/artifact03.yaml
  - directory/artifact04.yaml
EOF

  assertTrue "_validate_profile \"${__TEST_TEMP_DIR}/valid_multiple_exclamation_mark_artifact_success.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_valid_star_artifact_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/valid_star_artifact_success.yaml"
name: test
description: test profile
artifacts:
  - artifact01.yaml
  - !artifact02.yaml
  - directory/*
  - ${__TEST_TEMP_DIR}/tmp/directory/*
EOF

  assertTrue "_validate_profile \"${__TEST_TEMP_DIR}/valid_star_artifact_success.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_valid_star_exclamation_mark_artifact_success()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/valid_star_exclamation_mark_artifact_success.yaml"
name: test
description: test profile
artifacts:
  - artifact01.yaml
  - !artifact02.yaml
  - !directory/*
EOF

  assertTrue "_validate_profile \"${__TEST_TEMP_DIR}/valid_star_exclamation_mark_artifact_success.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_missing_name_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/missing_name_property_fail.yaml"
description: test profile
artifacts:
  - artifact01.yaml
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/missing_name_property_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_missing_description_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/missing_description_property_fail.yaml"
name: test
artifacts:
  - artifact01.yaml
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/missing_description_property_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_missing_artifacts_mapping_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/missing_artifacts_mapping_fail.yaml"
name: test
description: test profile
  - artifact01.yaml
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/missing_artifacts_mapping_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_empty_artifact_list_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/empty_artifact_list_fail.yaml"
name: test
description: test profile
artifacts:
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/empty_artifact_list_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}

test_validate_profile_invalid_property_fail()
{
  cat <<EOF >"${__TEST_TEMP_DIR}/invalid_property_fail.yaml"
non-existent-option: test
EOF

  assertFalse "_validate_profile \"${__TEST_TEMP_DIR}/invalid_property_fail.yaml\" \"${__TEST_TEMP_DIR}/uac/artifacts\""
}