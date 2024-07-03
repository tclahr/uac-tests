#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC1091,SC2006,SC2317

oneTimeSetUp()
{
  . "${UAC_DIR}/lib/get_user_home_list.sh"

  _get_current_user()
  {
    printf %b "uac"
  }

  __TEST_TEMP_DIR="${USHUNIT_TEMP_DIR}/test_get_user_home_list"

  mkdir -p "${__TEST_TEMP_DIR}"
  mkdir -p "${__TEST_TEMP_DIR}"/etc
  mkdir -p "${__TEST_TEMP_DIR}"/home/user01
  mkdir -p "${__TEST_TEMP_DIR}"/home/user02
  mkdir -p "${__TEST_TEMP_DIR}"/Users/user03
  mkdir -p "${__TEST_TEMP_DIR}"/Users/user04
  mkdir -p "${__TEST_TEMP_DIR}"/export/home/user05
  mkdir -p "${__TEST_TEMP_DIR}"/export/home/user06
  mkdir -p "${__TEST_TEMP_DIR}"/u/user07
  mkdir -p "${__TEST_TEMP_DIR}"/u/user08
  mkdir -p "${__TEST_TEMP_DIR}"/home/.shadow

  cat <<EOF >"${__TEST_TEMP_DIR}/etc/passwd"
root:x:0:0::/root:/bin/bash
bin:x:1:1::/:/usr/bin/false
daemon:x:2:2::/:/usr/bin/halt
mail:x:8:12::/var/spool/mail:/usr/bin/nologin
ftp:x:14:11::/srv/ftp:/usr/bin/shutdown
http:x:33:33::/srv/http:/usr/bin/sync
uac:x:1000:1000::/home/uac:/usr/bin/zsh
tyrion:x:1001:1001::/Users/tyrion:/bin/bash
git:x:967:967:git daemon user:/:/usr/bin/git-shell
eddard:x:1001:1001::/export/home/eddard:/bin/sh
EOF
}

test_get_user_home_list_skip_nologin_users_false_success()
{
  __test_actual=`_get_user_home_list false "${__TEST_TEMP_DIR}"`
  assertEquals "bin:/
daemon:/
eddard:/export/home/eddard
ftp:/srv/ftp
git:/
http:/srv/http
mail:/var/spool/mail
root:/root
shadow:/home/.shadow
tyrion:/Users/tyrion
uac:/home/uac
user01:/home/user01
user02:/home/user02
user03:/Users/user03
user04:/Users/user04
user05:/export/home/user05
user06:/export/home/user06
user07:/u/user07
user08:/u/user08" "${__test_actual}"
}

test_get_user_home_list_skip_nologin_users_true_success()
{
  __test_actual=`_get_user_home_list true "${__TEST_TEMP_DIR}"`
  assertEquals "eddard:/export/home/eddard
root:/root
shadow:/home/.shadow
tyrion:/Users/tyrion
uac:/home/uac
user01:/home/user01
user02:/home/user02
user03:/Users/user03
user04:/Users/user04
user05:/export/home/user05
user06:/export/home/user06
user07:/u/user07
user08:/u/user08" "${__test_actual}"
}
