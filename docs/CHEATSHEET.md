# Cheatsheet

Expublish supports various options that are listed in detail on the [Reference](./REFERENCE.md) page.

```bash
# Perform all task steps without writing changes (no commit, no tag, no push, no publish):
$ mix expublish.minor --dry-run

# Do not push the new version commit and tag to git and do not publish to hex:
$ mix expublish.minor --disable-push --disable-publish

# Skip test run:
$ mix expublish.minor --disable-test

# Allow untracked files while validating git working directory:
$ mix expublish.minor --allow-untracked

# If the package version is kept in a separate file:
$ mix expublish.patch --version-file=VERSION.txt

# Push to a different git branch and/or remote:
$ mix expublish.minor --branch=release --remote=upstream

# Custom tag-prefix which results in "release-0.0.1" instead of "v0.0.1":
$ mix expublish.minor --tag-prefix="release-"

# Use custom commit-, but no tag-prefix:
$ mix expublish.minor --tag-prefix="" --commit-prefix="Version bump"

# Release a pre-release version as next major:
$ mix expublish.alpha --as-major

# Release a stable pre-release version. Aborts if current version is already stable:
$ mix expublish.stable
```
