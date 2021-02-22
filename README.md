[![Hex.pm](https://img.shields.io/hexpm/v/expublish)](https://hex.pm/packages/expublish)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs.pm-purple)](https://hexdocs.pm/expublish)
[![Github.com](https://github.com/ucwaldo/expublish/actions/workflows/elixir.yml/badge.svg)](https://github.com/ucwaldo/expublish/actions)

# Expublish

Automate [SemVer](https://semver.org) and best practices for elixir package releases.

<span id="#installation"></span>

## Installation

Add `:expublish` to your dev dependencies in `mix.exs`:

```elixir
{:expublish, "~> 2.1", only: [:dev]}
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

## About

Using `mix expublish` guarantees:

- A clean git working directory
- Passing tests
- Increased version in mix.exs
- A new changelog entry
- A new version git commit and tag

Expublish was built with a CI integrated continuous release process in mind.
The mix task makes certain assumptions and automatically pushes and publishes the new package version to git and hex respectively.

This and other behavior can be changed using various [options](#options). Here are the commonly used ones:

```
# Go through all the task steps without any writing changes (no commit, no tag, no push, no publish):
$ mix expublish.minor --dry-run

# Do not push the new version commit and tag to git and do not publish the new package on hex:
$ mix expublish.minor --disable-push --disable-publish

# Skip the test run:
$ mix expublish.minor --disable-test

# Ignore untracked files in git check before creating a new release:
$ mix expublish.minor --allow-untracked

# Push the git commit to a different branch and/or remote:
$ mix expublish.minor --branch=release --remote=upstream
```

## Reference

The mix task is defined as: 

```
mix expublish.[level] [options]
```

### Level

| Level   | Description                                                  |
| ------- | -------------------------------------------------------------|
| `major` | When making incompatible API changes.                      |
| `minor` | When adding functionality in a backwards compatible manner. |
| `patch` | When making backwards compatible bug fixes.                 |

### Options

| Option              | Default    | Description                                       |
| ------------------- | ---------- | --------------------------------------------------|
| `-h, --help`        | `false`    | Print help.                                       |
| `-d, --dry-run`     | `false`    | Perform dry run (no writes, no commits).          |
| `--allow-untracked` | `false`    | Skip untracked files when checking git porcelain. |
| `--disable-test`    | `false`    | Disable test run.                                 |
| `--disable-publish` | `false`    | Disable hex publish.                              |
| `--disable-push`    | `false`    | Disable git push.                                 |
| `--branch=string`   | `"master"` | Remote branch for git push.                       |
| `--remote=string`   | `"origin"` | Remote name for git push.                         |

Apart from the mix task, Expublish exposes a [public interface](./Expublish.html) which can be used to create new releases from other elixir applications or scripts.
