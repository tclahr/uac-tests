#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2329

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/convert_size.sh"
  # stub _error_msg to suppress error output during tests
  _error_msg() { :; }
}

# ---------------------------------------------------------------------------
# No-input / defaults
# ---------------------------------------------------------------------------

test_convert_size_zero_input_returns_zero()
{
  __test_actual=`_convert_size 0 b`
  assertEquals "0" "${__test_actual}"
}

test_convert_size_empty_number_returns_zero()
{
  __test_actual=`_convert_size "" b`
  assertEquals "0" "${__test_actual}"
}

test_convert_size_no_args_returns_zero()
{
  __test_actual=`_convert_size`
  assertEquals "0" "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Same-unit conversions (value should be unchanged)
# ---------------------------------------------------------------------------

test_convert_size_bytes_to_bytes_success()
{
  __test_actual=`_convert_size "1024b" b`
  assertEquals "1024" "${__test_actual}"
}

test_convert_size_kilobytes_to_kilobytes_success()
{
  __test_actual=`_convert_size "4K" K`
  assertEquals "4" "${__test_actual}"
}

test_convert_size_megabytes_to_megabytes_success()
{
  __test_actual=`_convert_size "7M" M`
  assertEquals "7" "${__test_actual}"
}

test_convert_size_gigabytes_to_gigabytes_success()
{
  __test_actual=`_convert_size "3G" G`
  assertEquals "3" "${__test_actual}"
}

test_convert_size_terabytes_to_terabytes_success()
{
  __test_actual=`_convert_size "2T" T`
  assertEquals "2" "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Upward conversions (small unit → large unit)
# ---------------------------------------------------------------------------

test_convert_size_bytes_to_kilobytes_success()
{
  __test_actual=`_convert_size "2048b" k`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_bytes_to_megabytes_success()
{
  __test_actual=`_convert_size "3145728b" M`
  assertEquals "3" "${__test_actual}"
}

test_convert_size_bytes_to_gigabytes_success()
{
  __test_actual=`_convert_size "2147483648b" G`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_bytes_to_terabytes_success()
{
  __test_actual=`_convert_size "2199023255552b" T`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_kilobytes_to_megabytes_success()
{
  __test_actual=`_convert_size "5120K" M`
  assertEquals "5" "${__test_actual}"
}

test_convert_size_kilobytes_to_gigabytes_success()
{
  __test_actual=`_convert_size "2097152K" G`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_megabytes_to_gigabytes_success()
{
  __test_actual=`_convert_size "4096M" G`
  assertEquals "4" "${__test_actual}"
}

test_convert_size_megabytes_to_terabytes_success()
{
  __test_actual=`_convert_size "1048576M" T`
  assertEquals "1" "${__test_actual}"
}

test_convert_size_gigabytes_to_terabytes_success()
{
  __test_actual=`_convert_size "3072G" T`
  assertEquals "3" "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Downward conversions (large unit → small unit)
# ---------------------------------------------------------------------------

test_convert_size_kilobytes_to_bytes_success()
{
  __test_actual=`_convert_size "1K" b`
  assertEquals "1024" "${__test_actual}"
}

test_convert_size_megabytes_to_bytes_success()
{
  __test_actual=`_convert_size "1M" b`
  assertEquals "1048576" "${__test_actual}"
}

test_convert_size_gigabytes_to_bytes_success()
{
  __test_actual=`_convert_size "1G" b`
  assertEquals "1073741824" "${__test_actual}"
}

test_convert_size_terabytes_to_bytes_success()
{
  __test_actual=`_convert_size "1T" b`
  assertEquals "1099511627776" "${__test_actual}"
}

test_convert_size_gigabytes_to_kilobytes_success()
{
  __test_actual=`_convert_size "1G" K`
  assertEquals "1048576" "${__test_actual}"
}

test_convert_size_terabytes_to_megabytes_success()
{
  __test_actual=`_convert_size "1T" M`
  assertEquals "1048576" "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Suffix variant aliases
# ---------------------------------------------------------------------------

test_convert_size_suffix_lowercase_k_success()
{
  __test_actual=`_convert_size "1k" b`
  assertEquals "1024" "${__test_actual}"
}

test_convert_size_suffix_kb_success()
{
  __test_actual=`_convert_size "1kb" b`
  assertEquals "1024" "${__test_actual}"
}

test_convert_size_suffix_KB_success()
{
  __test_actual=`_convert_size "1KB" b`
  assertEquals "1024" "${__test_actual}"
}

test_convert_size_suffix_Kb_success()
{
  __test_actual=`_convert_size "1Kb" b`
  assertEquals "1024" "${__test_actual}"
}

test_convert_size_suffix_kB_success()
{
  __test_actual=`_convert_size "1kB" b`
  assertEquals "1024" "${__test_actual}"
}

test_convert_size_suffix_lowercase_m_success()
{
  __test_actual=`_convert_size "1m" b`
  assertEquals "1048576" "${__test_actual}"
}

test_convert_size_suffix_mb_success()
{
  __test_actual=`_convert_size "1mb" b`
  assertEquals "1048576" "${__test_actual}"
}

test_convert_size_suffix_MB_success()
{
  __test_actual=`_convert_size "1MB" b`
  assertEquals "1048576" "${__test_actual}"
}

test_convert_size_suffix_Mb_success()
{
  __test_actual=`_convert_size "1Mb" b`
  assertEquals "1048576" "${__test_actual}"
}

test_convert_size_suffix_mB_success()
{
  __test_actual=`_convert_size "1mB" b`
  assertEquals "1048576" "${__test_actual}"
}

test_convert_size_suffix_lowercase_g_success()
{
  __test_actual=`_convert_size "1g" b`
  assertEquals "1073741824" "${__test_actual}"
}

test_convert_size_suffix_gb_success()
{
  __test_actual=`_convert_size "1gb" b`
  assertEquals "1073741824" "${__test_actual}"
}

test_convert_size_suffix_GB_success()
{
  __test_actual=`_convert_size "1GB" b`
  assertEquals "1073741824" "${__test_actual}"
}

test_convert_size_suffix_Gb_success()
{
  __test_actual=`_convert_size "1Gb" b`
  assertEquals "1073741824" "${__test_actual}"
}

test_convert_size_suffix_gB_success()
{
  __test_actual=`_convert_size "1gB" b`
  assertEquals "1073741824" "${__test_actual}"
}

test_convert_size_suffix_lowercase_t_success()
{
  __test_actual=`_convert_size "1t" b`
  assertEquals "1099511627776" "${__test_actual}"
}

test_convert_size_suffix_tb_success()
{
  __test_actual=`_convert_size "1tb" b`
  assertEquals "1099511627776" "${__test_actual}"
}

test_convert_size_suffix_TB_success()
{
  __test_actual=`_convert_size "1TB" b`
  assertEquals "1099511627776" "${__test_actual}"
}

test_convert_size_suffix_Tb_success()
{
  __test_actual=`_convert_size "1Tb" b`
  assertEquals "1099511627776" "${__test_actual}"
}

test_convert_size_suffix_tB_success()
{
  __test_actual=`_convert_size "1tB" b`
  assertEquals "1099511627776" "${__test_actual}"
}

test_convert_size_suffix_c_bytes_success()
{
  __test_actual=`_convert_size "512c" b`
  assertEquals "512" "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Target unit aliases
# ---------------------------------------------------------------------------

test_convert_size_target_c_alias_success()
{
  __test_actual=`_convert_size "1K" c`
  assertEquals "1024" "${__test_actual}"
}

test_convert_size_target_kb_alias_success()
{
  __test_actual=`_convert_size "2048b" kb`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_target_KB_alias_success()
{
  __test_actual=`_convert_size "2048b" KB`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_target_mb_alias_success()
{
  __test_actual=`_convert_size "2M" mb`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_target_GB_alias_success()
{
  __test_actual=`_convert_size "2G" GB`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_target_tb_alias_success()
{
  __test_actual=`_convert_size "1T" tb`
  assertEquals "1" "${__test_actual}"
}

# ---------------------------------------------------------------------------
# No suffix (plain number treated as bytes)
# ---------------------------------------------------------------------------

test_convert_size_no_suffix_input_to_bytes_success()
{
  __test_actual=`_convert_size "2048" b`
  assertEquals "2048" "${__test_actual}"
}

test_convert_size_no_suffix_input_to_kilobytes_success()
{
  __test_actual=`_convert_size "2048" K`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_no_suffix_no_target_default_bytes_success()
{
  __test_actual=`_convert_size "512"`
  assertEquals "512" "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Rounding behaviour
# ---------------------------------------------------------------------------

test_convert_size_rounds_half_up_success()
{
  # 1536 bytes / 1024 = 1.5 → rounds to 2
  __test_actual=`_convert_size "1536b" K`
  assertEquals "2" "${__test_actual}"
}

test_convert_size_rounds_down_success()
{
  __test_actual=`_convert_size "1023b" K`
  assertEquals "1" "${__test_actual}"
}

# ---------------------------------------------------------------------------
# Error cases
# ---------------------------------------------------------------------------

test_convert_size_invalid_suffix_returns_zero()
{
  __test_actual=`_convert_size "10X" b`
  assertEquals "0" "${__test_actual}"
}

test_convert_size_invalid_target_returns_zero()
{
  __test_actual=`_convert_size "10K" Z`
  assertEquals "0" "${__test_actual}"
}

test_convert_size_non_numeric_input_returns_zero()
{
  __test_actual=`_convert_size "abc" b`
  assertEquals "0" "${__test_actual}"
}

test_convert_size_empty_string_input_returns_zero()
{
  __test_actual=`_convert_size "" b`
  assertEquals "0" "${__test_actual}"
}

test_convert_size_invalid_suffix_return_code_failure()
{
  assertFalse "`_convert_size "10X" b`"
}

test_convert_size_non_numeric_return_code_failure()
{
  assertFalse "`_convert_size "abc" b`"
}