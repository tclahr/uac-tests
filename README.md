# UAC (Unix-like Artifacts Collector) Tests

[![ShellCheck](https://github.com/tclahr/uac-unit-test/actions/workflows/shellcheck.yaml/badge.svg)](https://github.com/tclahr/uac-unit-test/actions/workflows/shellcheck.yaml)
[![GitHub](https://img.shields.io/github/license/tclahr/uac-unit-test?style=flat)](LICENSE)

This project includes tests to ensure the quality, maintainability, and trustworthiness of UAC.

UAC source code is available here: [github.com/tclahr/uac](https://github.com/tclahr/uac)

## Dependencies

- The [UAC](https://github.com/tclahr/uac) code
- The [ushunit](https://github.com/tclahr/ushunit) unit testing framework

## Getting Started

Development for UAC is easy, as the tool is written in shell script. UAC uses the Bourne shell (/bin/sh) on the target system. By adhering to the Bourne shell, UAC remains portable and allows it to run on any Unix-like system.

Clone all required repositories.

```shell
git clone https://github.com/tclahr/uac.git
git clone https://github.com/tclahr/ushunit.git
git clone https://github.com/tclahr/uac-tests.git
```

## How to run the tests

From the ushunit directory, run the following command to run all tests.

```shell
cd ushunit
UAC_DIR="../uac" ./ushunit -i ../uac-tests/tests/lib/* ../uac-tests/tests/*
```

## Support

For general help using UAC, please refer to the [project documentation page](https://tclahr.github.io/uac-docs). For additional help, you can use one of the following channels:

- [Discord](https://discord.com/invite/digitalforensics) (For live discussion with the community and UAC team)
- [GitHub](https://github.com/tclahr/uac/issues) (Bug reports and contributions)
- [Twitter](https://twitter.com/tclahr) (Get the news fast)

## Support the Project

If you find UAC helpful, please give us a ⭐ on [GitHub](https://github.com/tclahr/uac)! This helps others discover the project and motivates us to improve it further.

## License

The UAC project uses the [Apache License Version 2.0](LICENSE) software license.
