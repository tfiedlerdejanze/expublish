# About Expublish

Inspired by various release utilities that exist for different languages and ecosystems,
Expublish provides a mix task that guarantees a clean and functioning project state
before it performs the steps required to release a new package version following
[semantic versioning](https://semver.org/) conventions.

Using `mix expublish` guarantees:

- A clean git working directory
- Passing tests
- Increased version in mix.exs
- A new changelog entry
- A new version git commit and tag

Expublish was created with a continuous release process in mind but it can of
course be used from anywhere mix and git are available. Using it saves
time and headaches, helps projects to keep a clean and secure version
history and provides a consistent release experience to maintainers.

By default the task will _publish_ and _push_ the new package version to hex and
git respectively and when not executed from CI, it's recommended to
always perform a `--dry-run` before rerunning the task without said option.

`mix expublish` supports a bunch of command-line options, checkout the [Reference](./REFERENCE.md) and [Example](./EXAMPLES.md) pages.

