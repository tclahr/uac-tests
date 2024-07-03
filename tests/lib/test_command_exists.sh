#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/command_exists.sh"
}

test_command_exists_fail()
{
  assertFalse "command_exists \"InvalidOrUnknownCommandForTesting\""
}

test_command_exists_type_success()
{
  if commandExists "type"; then
    assertTrue "command_exists \"cp\""
  else
    skipTest "no such file or directory: 'type'"
  fi
}

test_command_exists_command_success()
{
  # stub
  type()
  {
    return 1
  }
  
  if commandExists "command"; then
    assertTrue "command_exists \"cp\""
  else
    skipTest "no such file or directory: 'command'"
  fi
}

test_command_exists_which_success()
{
  # stub
  type()
  {
    return 1
  }
  command()
  {
    return 1
  }
  
  if commandExists "which"; then
    assertTrue "command_exists \"cp\""
  else
    skipTest "no such file or directory: 'which'"
  fi
}
