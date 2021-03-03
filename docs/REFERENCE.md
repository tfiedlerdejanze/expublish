# Reference

Expublish defines the mix task as:

```
mix expublish.[level] [options]
```

## Levels

| Level    | Description                                                               |
| -------- | ------------------------------------------------------------------------- |
| `major`  | When making incompatible API changes.                                     |
| `minor`  | When adding functionality in a backwards compatible manner.               |
| `patch`  | When making backwards compatible bug fixes.                               |
| `stable` | When declaring a pre-release stable. Version level will not be increased. |
| `rc`     | Pre-release for final test stage of next patch version.                   |
| `beta`   | Pre-release for later test stage of next patch version.                   |
| `alpha`  | Pre-release for early test stage of next patch version.                   |

Pre-releases are always considered unstable, however their next version level can
still be changed by using one of the `--as-major` or `--as-minor` options.

## Options

| Option                   | Default             | Description                                          |
| ------------------------ | ------------------- | ---------------------------------------------------- |
| `-d, --dry-run`          | `false`             | Perform dry run release                              |
| `-h, --help`             | `false`             | Print help                                           |
| `--allow-untracked`      | `false`             | Allow untracked files and add them in version commit |
| `--as-major`             | `false`             | Only for pre-release level                           |
| `--as-minor`             | `false`             | Only for pre-release level                           |
| `--disable-publish`      | `false`             | Disable hex publish                                  |
| `--disable-push`         | `false`             | Disable git push                                     |
| `--disable-test`         | `false`             | Disable test run                                     |
| `--branch=string`        | `"master"`          | Remote branch for git push                           |
| `--commit-prefix=string` | `"Version release"` | Prefix for commit message                            |
| `--remote=string`        | `"origin"`          | Remote name for git push                             |
| `--tag-prefix=string`    | `"v"`               | Prefix for release tag                               |
| `--version-file=string`  | `"mix.exs"`         | When working with a separate version file \*         |

\* Expublish expects given file to contain _nothing_ but the current version of a
project and will overwrite the file with the new version while releasing.
