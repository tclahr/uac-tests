## UAC (Unix-like Artifacts Collector) Unit Test

[![ShellCheck](https://github.com/tclahr/uac-unit-test/actions/workflows/shellcheck.yaml/badge.svg)](https://github.com/tclahr/uac-unit-test/actions/workflows/shellcheck.yaml)
[![GitHub](https://img.shields.io/github/license/tclahr/uac-unit-test?style=flat)](LICENSE)

This project is a testing framework for UAC (Unix-like Artifacts Collector) tool. It provides a simple way to test the quality and make UAC maintainable and trustworthy.

UAC source code is available here: [github.com/tclahr/uac](https://github.com/tclahr/uac)

## Getting Started

Development for UAC is easy, as the tool is written in shell script. UAC uses the Bourne shell (/bin/sh) on the target system. By adhering to the Bourne shell, UAC remains portable and allows it to run on any Unix-like system.

## Usage

```shell
Usage: ./run_test [-h] UAC_DIR OPERATING_SYSTEM SYSTEM_ARCH
                  USERNAME HOSTNAME <test_file>

Optional Arguments:
  -h, --help        Display this help and exit.

Positional Arguments:
  UAC_DIR           UAC source code directory.
  OPERATING_SYSTEM  Specify the host operating system.
                    Options: aix, android, esxi, freebsd, linux, macos, netbsd
                             netscaler, openbsd, solaris
  SYSTEM_ARCH       Specify the host system archtecture.
  USERNAME          Specify the username is running the unit test.
  HOSTNAME          Specify the host system hostname.

  <test_file>       Test file(s).
```

## How to run tests

Go to the directory you want to develop. 

Clone both projects:

```shell
git clone https://github.com/tclahr/uac
git clone https://github.com/tclahr/uac-unit-test
```

Go to the uac-unit-test directory and run the tests.

**Run only one test:**

```shell
adam@grayskull$ ./run_test ../uac linux arm64 adam grayskull tests/test_get_epoch_date.sh
```

**Run multiple tests:**

```shell
snow@westeros$ ./run_test ../uac macos x86_64 snow westeros tests/test_get_epoch_date.sh tests/test_log_message.sh
```

**Run all tests:**

```shell
ruth@ozark$ ./run_test ../uac freebsd i686 ruth ozark tests/*
```

## Support

For additional help, you can use one of the channels to ask a question:

- [Discord](https://discord.com/invite/digitalforensics) (For live discussion with the community and UAC team)
- [GitHub](https://github.com/tclahr/uac-unit-test/issues) (Bug reports and contributions)
- [Twitter](https://twitter.com/tclahr) (Get the news fast)

## License

The project uses the [Apache License Version 2.0](LICENSE) software license.