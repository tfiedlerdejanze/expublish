[![Hex.pm](https://img.shields.io/hexpm/v/expublish)](https://hex.pm/packages/expublish)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs.pm-purple)](https://hexdocs.pm/expublish)
[![Github.com](https://github.com/tfiedlerdejanze/expublish/actions/workflows/elixir.yml/badge.svg)](https://github.com/tfiedlerdejanze/expublish/actions)
[![Coverage Status](https://coveralls.io/repos/github/tfiedlerdejanze/expublish/badge.svg?branch=master)](https://coveralls.io/github/tfiedlerdejanze/expublish?branch=master)

# Expublish

Automates semantic release versioning and best practices for elixir packages.

Explublish helps keeping a clean and trackable version history in a project,
while providing a consistent and easy release experience to its maintainers.
It was created with a continuous release process in mind and can be used to
fully automate the release of new package versions.

## What it does

Inspired by various release utilities that exist for different languages and ecosystems,
Expublish provides a mix task that guarantees a clean and functioning project state
before it performs the steps required to release a new package version following
[semantic versioning](https://semver.org/) conventions.

Using `mix expublish` guarantees:

- a clean git working directory.
- passing tests.
- an increased version in mix.exs or version file.
- a new curated changelog entry.
- a new version git commit and tag.
- `git push` to given remote and branch.
- `mix hex.publish` to release the new package version and documentation to users.

Some of the steps can be opted out from and when not executed from CI,
it's recommended to _always_ execute a `--dry-run` before rerunning the expublish task without said option.

`mix expublish` supports various command-line options, check out the [Cheatsheet](./docs/CHEATSHEET.md) and [Reference](./docs/REFERENCE.md) pages.

<span id="getting-started"></span>

## Getting started

1\. Follow the [installation](./docs/INSTALLATION.md) instructions.

2\. For every new release, create a `RELEASE.md` containing a new changelog entry:

```bash
$ echo "- changelog entry one\n- changelog entry two" > RELEASE.md
```

3\. Run `mix expublish`:

```bash
$ mix expublish.minor
```

_Note that in case the push or publish step fail because of missing authentication
or a failing network, the task must not be rerun. Instead run `git push` or
`mix hex.publish` to finish releasing the new version._

#### Fully automate releases

Expublish can fully automate the release process, inferring the version bump and generating the changelog entry
from commits implementing the [commitizen](#commitezen) specification.

```
mix expublish.release
```

## Installation

See the [Installation](./docs/INSTALLATION.md) page to learn how to set up Expublish.

<span id="version-levels"></span>

<span id="cheatsheet"></span>

## Cheatsheet

See the [Cheatsheet](./docs/CHEATSHEET.md) page to get a quick overview on how to use the various options.

<span id="version-levels"></span>

## Version levels

See the [Version levels](./docs/VERSION_LEVELS.md) page to learn how Expublish increases version levels.

<span id="commitizen"></span>

## Commitizen

Expublish can automatically generate changelog entries from commits implementing the [commitizen]() specification.
All commits _prefixed_ by one of the following keywords will be included in the generated changelog entry, while all others
will be ommited: `fix`, `feat`, `BREAKING CHANGE`.

<span id="quick-reference"></span>

## Quick Reference

See the full [Reference](./docs/REFERENCE.md) page to learn about all valid `mix expublish`
task levels, options and defaults.

```
Usage: mix expublish.[level] [options]

level:
  major   - Publish next major version
  minor   - Publish next minor version
  patch   - Publish next patch version
  stable  - Publish current stable version from pre-release
  rc      - Publish release-candidate pre-release of next patch version
  beta    - Publish beta pre-release of next patch version
  alpha   - Publish alpha pre-release of next patch version
  release - Publish a new version inferred by commits following the commitizen specification

options:
  -d, --dry-run           - Perform dry run (no writes, no commits)
  --allow-untracked       - Allow untracked files during release
  --as-major              - Only for pre-release level
  --as-minor              - Only for pre-release level
  --disable-publish       - Disable hex publish
  --disable-push          - Disable git push
  --disable-test          - Disable test run
  --commitizen            - Generate changelog from commits following the commitizen specification
  --changelog-date-time   - Use date-time instead of date in new changelog entry
  --branch=string         - Remote branch to push to, default: "master"
  --remote=string         - Remote name to push to, default: "origin"
  --commit-prefix=string  - Custom commit prefix, default:  "Version release"
  --tag-prefix=string     - Custom tag prefix, default: "v"
  --version-file=string   - When working with a separate version file
```

<span id="links-and-resources"></span>

## Links and resources

- [Hex.pm docs](https://hex.pm/docs/usage)
- [Keep a changelog](https://keepachangelog.com/en/1.1.0/)
- [SemVer specification](https://semver.org/)
- [Blog post on private hex auth](https://medium.com/@brunoripa/elixir-application-deployment-using-a-ci-and-private-hex-pm-dependencies-23f45fe04973)
- [Example github action](https://github.com/tfiedlerdejanze/expublish/blob/master/.github/workflows/release.yml#L31-L42)
