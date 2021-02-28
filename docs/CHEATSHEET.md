# Cheatsheet

```bash
# Perform all task steps without writing changes (no commit, no tag, no push, no publish):
$ mix expublish.minor --dry-run

# Do not push the new version commit and tag to git and do not publish to hex:
$ mix expublish.minor --disable-push --disable-publish

# Allow untracked files while validating git working directory and add them in version commit:
$ mix expublish.minor --allow-untracked

# Skip test run:
$ mix expublish.minor --disable-test

# If the package version is kept in a separate file:
$ mix expublish.patch --version-file=VERSION.txt

# Push the git commit to a different branch and/or remote:
$ mix expublish.minor --branch=release --remote=upstream

# Use custom tag-prefix so it results in "release-0.0.1" instead of "v0.0.1":
$ mix expublish.minor --tag-prefix="release-"

# Use custom commit- and no tag-prefix:
$ mix expublish.minor --tag-prefix="" --commit-prefix="Version bump"

# Release a pre-release version as next major:
$ mix expublish.alpha --as-major

# Release a stable pre-release version. Aborts if current version is already stable:
$ mix expublish.stable
```
