#!/bin/sh

# shellcheck disable=SC2034

setup_test() {
  TEMP_DATA_DIR="${TEMP_DIR}/test_command_collector"
  mkdir -p "${TEMP_DATA_DIR}"
  UAC_LOG_FILE="${TEMP_DATA_DIR}/uac.log"

  __ps() {
    cat << EOF
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 07:54 ?        00:00:01 /sbin/init
root           2       0  0 07:54 ?        00:00:00 [kthreadd]
root           3       2  0 07:54 ?        00:00:00 [rcu_gp]
EOF
  }

  __uname() {
    printf %b "Linux tclahr-p52 5.16.16-200.fc35.x86_64 #1 SMP PREEMPT Sat Mar 19 13:52:41 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux\n"
  }

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

test_simple_command() {
  assert "command_collector \"\" \"__ps\" \"root_directory\" \"\" \"ps.txt\" \"\" \"\""
}

test_simple_command_output_file_exists() {
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/ps.txt"
}

test_simple_command_output_file_matches_content() {
  assert_matches_file_content "kthreadd" "${TEMP_DATA_DIR}/root_directory/ps.txt"
}

test_simple_command_empty_stderr_file() {
  assert_file_not_exists "${TEMP_DATA_DIR}/root_directory/ps.txt.stderr"
}

test_simple_command_stderr_file_exists() {
  command_collector "" "__invalidcommand" "root_directory" "" "__invalidcommand.txt" "" ""
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/__invalidcommand.txt.stderr"
}

test_simple_command_compressed_output_file() {
  assert "command_collector \"\" \"__uname\" \"root_directory\" \"\" \"uname.txt\" \"\" \"true\""
}

test_simple_command_compressed_output_file_exists() {
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/uname.txt.gz"
}

test_simple_command_custom_stderr_file_exists() {
  command_collector "" "__invalidcommand" "root_directory" "" "__invalidcommand.txt" "custom.stderr" ""
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/custom.stderr"
}

test_simple_command_output_directory() {
  assert "command_collector \"\" \"__ps\" \"root_directory\" \"output_directory\" \"ps.txt\" \"\" \"\""
}

test_simple_command_output_directory_output_file_exists() {
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/output_directory/ps.txt"
}

test_simple_command_output_directory_output_file_matches() {
  assert_matches_file_content "kthreadd" "${TEMP_DATA_DIR}/root_directory/output_directory/ps.txt"
}

test_empty_command() {
  assert_fails "command_collector \"\" \"\" \"root_directory\" \"\" \"empty_command.txt\" \"\" \"\""
}

test_loop_command_output_file_exists() {
  command_collector "ls -l \"${MOUNT_POINT}\"/proc/[0-9]*/cmd | awk -F\"/proc/|/cmd\" '{print \$2}'" "cat \"${MOUNT_POINT}\"/proc/%line%/cmd" "root_directory" "proc/%line%" "proc_%line%_cmd.txt" "" ""
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/proc/1/proc_1_cmd.txt"
}

test_loop_command_compressed_output_file_exists() {
  command_collector "ls -l \"${MOUNT_POINT}\"/proc/[0-9]*/cmd | awk -F\"/proc/|/cmd\" '{print \$2}'" "cat \"${MOUNT_POINT}\"/proc/%line%/cmd" "root_directory" "proc/%line%" "proc_%line%_cmd.txt" "custom_%line%.stderr" "true"
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/proc/1/proc_1_cmd.txt.gz"
}

test_loop_command_custom_stderr_file_exists() {
  command_collector "ls -l \"${MOUNT_POINT}\"/proc/[0-9]*/cmd | awk -F\"/proc/|/cmd\" '{print \$2}'" "cat \"${MOUNT_POINT}\"/proc/%line%/cmd1" "root_directory" "proc/%line%" "proc_%line%_cmd.txt" "custom_%line%.stderr" "true"
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/proc/1/custom_1.stderr"
}

test_replace_output_file_variable_in_command() {
  command_collector "" "cp \"${MOUNT_POINT}/bin/cp\" %output_file%" "root_directory" "" "replace_output_file_variable.txt" "" ""
  assert_file_exists "${TEMP_DATA_DIR}/root_directory/replace_output_file_variable.txt"
}