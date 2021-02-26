# Examples

- [Simple github workflow]()
- More to come..

## Cheatsheet

```bash
# Perform all task steps without writing changes (no commit, no tag, no push, no publish):
$ mix expublish.minor --dry-run

# Do not push the new version commit and tag to git and do not publish the to hex:
$ mix expublish.minor --disable-push --disable-publish

# Do not run the tests:
$ mix expublish.minor --disable-test

# Ignore untracked files while validating git working directory:
$ mix expublish.minor --allow-untracked

# Push the git commit to a different branch and/or remote:
$ mix expublish.minor --branch=release --remote=upstream

# Use custom commit- and no tag-prefix:
$ mix expublish.minor --tag-prefix="" --commit-prefix="Version bump"

# Force minor bump while creating a new pre-release:
$ mix expublish.beta --as-minor
=> "1.1.0-beta"

# Force major bump while creating a new pre-release:
$ mix expublish.rc --as-major
=> "2.0.0-rc"
```

## Versioning

Version increases follow [semantic versioning](https://semver.org/) conventions.
Note that for pre-releases, using the current pre-release or `patch` level has
the same effect: bump a patch version. When creating a new pre-release the
version level can be changed using one of the `--as-major` or `--as-minor` options.

Pre-releases follow the order of `stable > rc > beta > alpha`, hence trying to
create a `beta` from a `rc` will abort the mix task and log an error message.

```
# current version: "0.0.0"

expublish.alpha --as-major  => "1.0.0-alpha"
expublish.patch             => "1.0.1-alpha"
expublish.alpha             => "1.0.2-alpha"
expublish.beta              => "1.0.3-beta"
expublish.rc                => "1.0.4-rc"
expublish.beta              => Error: current version rc > beta
expublish.stable            => "1.0.4"
expublish.patch             => "1.0.5"
expublish.stable            => Error: can not release already stable version
expublish.minor             => "1.1.0"
expublish.alpha             => "1.1.1-alpha"
expublish.alpha             => "1.1.2-alpha"
expublish.beta              => "1.1.3-beta"
expublish.rc                => "1.1.4-rc"
expublish.stable            => "1.1.4"
expublish.rc --as-minor     => "1.2.0-rc"
```
