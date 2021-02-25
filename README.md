[![Hex.pm](https://img.shields.io/hexpm/v/expublish)](https://hex.pm/packages/expublish)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs.pm-purple)](https://hexdocs.pm/expublish)
[![Github.com](https://github.com/ucwaldo/expublish/actions/workflows/elixir.yml/badge.svg)](https://github.com/ucwaldo/expublish/actions)

# Expublish

Automate [SemVer](https://semver.org) and best practices for elixir package releases.

<span id="#installation"></span>

## Installation

Add `:expublish` to your dev dependencies in `mix.exs`:

```elixir
{:expublish, "~> 2.3", only: [:dev]}
```

Create a `CHANGELOG.md` in the root folder of your project. It must contain a placeholder:

```text
<!-- %% CHANGELOG_ENTRIES %% -->
```

Do not keep track of the release file. Put the following line in your `.gitignore`:

```text
RELEASE.md
```

The file is deleted after every successful release.

<span id="#usage"></span>

## Usage

1\. Create a new `RELEASE.md` containing the new changelog entry:

```bash
$ echo "- changelog entry one\n- changelog entry two" > RELEASE.md
```

2\. Run one of `mix expublish.(major|minor|patch)`:

```bash
$ mix expublish.minor
```

<span id="#about"></span>

## About

Releasing a new package version can be a swift task, but doing it right requires
some often manual steps that are easy to forget or mess up. Expublish provides a mix task that
guarantees a clean and functioning project state before it performs the steps required to
release a new package version following [semantic versioning](https://semver.org/) conventions.

Using `mix expublish` guarantees:

- A clean git working directory
- Passing tests
- Increased version in mix.exs
- A new changelog entry
- A new version git commit and tag

Expublish was created with a continuous release process in mind. It's straight forward to be used
from any CI server as it has similar requirements to the ones of a traditional test environment: elixir, mix and git need to be available at runtime. Here is an example [github workflow](https://github.com/ucwaldo/expublish/blob/master/.github/workflows/release.yml#L31-L42).

By default, the mix task will try to publish and push the new package version to hex and git respectively.
This and other behavior can be changed using various [command-line options](#reference). Here are some commonly used ones:

```bash
# Perform all task steps without any writing changes (no commit, no tag, no push, no publish):
$ mix expublish.minor --dry-run

# Do not push the new version commit and tag to git and do not publish the new package on hex:
$ mix expublish.minor --disable-push --disable-publish

# Disable the test run:
$ mix expublish.minor --disable-test

# Ignore untracked files while validating git working directory:
$ mix expublish.minor --allow-untracked

# Push the git commit to a different branch and/or remote:
$ mix expublish.minor --branch=release --remote=upstream

# Use custom commit- and no tag-prefix:
$ mix expublish.minor --tag-prefix="" --commit-prefix="Version bump"
```

### Note on hex authentication

Regardless of publishing to [hex.pm](https://hex.pm/) or a self-hosted hex repository, the shell environment where
`mix expublish` is being executed must be authenticated for the publishing step to succeed.

While publishing to hex.pm usually requires a valid `HEX_API_TOKEN` to be defined in the current environment, self-hosted repositories can use a range of various authentication methods.

Check the documentation on [publishing](https://hex.pm/docs/publish) and [self-hosting](https://hex.pm/docs/self_hosting) to find out more.

## Reference

The mix task is defined as:

```
mix expublish.[level] [options]
```

### Level

| Level   | Description                                                 |
| ------- | ----------------------------------------------------------- |
| `major` | When making incompatible API changes.                       |
| `minor` | When adding functionality in a backwards compatible manner. |
| `patch` | When making backwards compatible bug fixes.                 |

### Options

| Option                   | Default             | Description                |
| ------------------------ | ------------------- | -------------------------- |
| `-d, --dry-run`          | `false`             | Perform dry run release    |
| `-h, --help`             | `false`             | Print help                 |
| `--allow-untracked`      | `false`             | Allow untracked files      |
| `--disable-publish`      | `false`             | Disable hex publish        |
| `--disable-push`         | `false`             | Disable git push           |
| `--disable-test`         | `false`             | Disable test run           |
| `--branch=string`        | `"master"`          | Remote branch for git push |
| `--commit-prefix=string` | `"Version release"` | Prefix for commit message  |
| `--remote=string`        | `"origin"`          | Remote name for git push   |
| `--tag-prefix=string`    | `"v"`               | Prefix for release tag     |
