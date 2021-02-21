[![Hex.pm](https://img.shields.io/hexpm/v/expublish)](https://hex.pm/packages/expublish)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs.pm-brightgreen)](https://hexdocs.pm/expublish)

# Expublish

Automated version and changelog management for elixir packages.

[How to install](./INSTALLATION.md)

```bash
Usage: mix publish.[level] [--dry-run | -d] [--branch=release]

Flags:
  -d, --dry-run           - Perform dry run (no writes, no commits)
  -u, --skip-push         - Disable git push
  -p, --skip-publish      - Disable hex publish
  -t, --skip-test         - Disable test run
  -b, --branch=string     - Remote branch to push to, default: "master"
  -r, --remote=string     - Remote name to push to, default: "origin"
  -h, --help              - Print this help

Semver level:
  major   - Publish major version
  minor   - Publish minor version
  patch   - Publish patch version

```

## Release a new package

1. Create a `RELEASE.md` containing the new changelog entry.
2. Run `mix publish.[level]`.

```bash
$ echo "- changelog entry one\n- changelog entry two" > RELEASE.md
$ mix publish.minor
```

The mix task attempts to guarantee the following:

- Clean git working directory
- Passing tests
- Bumped version in mix.exs
- Decent changelog entry
- Git commit and tag
- Publish to hex
