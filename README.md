<div align="center">

# asdf-sonar-scanner [![Build](https://github.com/davividal/asdf-sonar-scanner/actions/workflows/build.yml/badge.svg)](https://github.com/davividal/asdf-sonar-scanner/actions/workflows/build.yml) [![Lint](https://github.com/davividal/asdf-sonar-scanner/actions/workflows/lint.yml/badge.svg)](https://github.com/davividal/asdf-sonar-scanner/actions/workflows/lint.yml)

[sonar-scanner](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add sonar-scanner
# or
asdf plugin add sonar-scanner https://github.com/davividal/asdf-sonar-scanner.git
```

sonar-scanner:

```shell
# Show all installable versions
asdf list-all sonar-scanner

# Install specific version
asdf install sonar-scanner latest

# Set a version globally (on your ~/.tool-versions file)
asdf global sonar-scanner latest

# Now sonar-scanner commands are available
sonar-scanner --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/davividal/asdf-sonar-scanner/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Davi Koscianski Vidal](https://github.com/davividal/)
