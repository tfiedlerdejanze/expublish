[![Hex.pm](https://img.shields.io/hexpm/v/expublish)](https://hex.pm/packages/expublish)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs.pm-purple)](https://hexdocs.pm/expublish)
[![Github.com](https://github.com/ucwaldo/expublish/actions/workflows/elixir.yml/badge.svg)](https://github.com/ucwaldo/expublish/actions)

# Expublish

Automate elixir package version and changelog management. Using `mix expublish` guarantees:

- A clean git working directory
- Passing tests
- Increased version in mix.exs
- New changelog entry
- Commit, tag and git push
- Hex publish

<span id="#install"></span>

## How to install

Add `:expublish` to your dev dependencies in `mix.exs`:

```elixir
{:expublish, "~> 1.1", only: [:dev]}
```

Create a `CHANGELOG.md` in the root folder of your project. It must contain a placeholder:

```text
<!-- %% CHANGELOG_ENTRIES %% -->
```

<span id="#how-to-use"></span>

## How to use

Create a `RELEASE.md` containing the new changelog entry.

```bash
$ echo "- changelog entry one\n- changelog entry two" > RELEASE.md
```

Run one of `mix expublish.(major|minor|patch)`.

```bash
$ mix expublish.minor
```

<span id="#reference"></span>

## Reference

```bash
Usage: mix expublish.[level] [options]

level:
  major - Publish major version
  minor - Publish minor version
  patch - Publish patch version

options:
  -d, --dry-run       - Perform dry run (no writes, no commits)
  --branch=string     - Remote branch to push to, default: "master"
  --remote=string     - Remote name to push to, default: "origin"
  --disable-publish   - Disable hex publish
  --disable-push      - Disable git push
  --disable-test      - Disable test run
```
