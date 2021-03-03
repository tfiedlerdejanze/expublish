# Installation

1\. Add `:expublish` to the dev dependencies in `mix.exs`:

```elixir
{:expublish, "~> 2.5", only: [:dev], runtime: false}
```

2\. Create a `CHANGELOG.md` in the root folder of the project. It must contain a placeholder:

```text
<!-- %% CHANGELOG_ENTRIES %% -->
```

3\. Put the following line in `.gitignore`:

```text
RELEASE.md
```

Alternatively, the `RELEASE.md` can be kept inside version control and used
when publishing from CI. The file is deleted after every successful release.

4\. (Optional) While writing the final package version, Expublish expects the version
to be located where `mix new [package]` initially placed it. If it wasn't changed skip
the next couple paragraphs and read about [Publishing to hex](#publishing-to-hex).

As it is common to keep the package version in a module attribute in `mix.exs`,
Expublish supports following syntax as well.

```
@version "1.0.0"
# ...
version: @version
```

If the package version is maintained in a separate file, expublish can be made aware
of that with the appropriate [option](./REFERENCE.md):

```bash
$ mix expublish.patch --version-file=VERSION.txt`
```

where `VERSION.txt` is a file containing nothing but the current project version:

```
1.0.0
```

with a mix.exs reading said file in `project/0`:

```
version: File.read("VERSION.txt") |> String.tim()
```

## Publishing to hex

Before publishing a package for the first time, do read the
[hex documentation on publishing](https://hex.pm/docs/publish) and
add the required metadata in mix.exs.

Regardless of publishing to [hex.pm](https://hex.pm/) or a self-hosted hex repository,
the shell environment where `mix expublish` is being executed must authenticate for
the publishing step to succeed.

Hex.pm usually requires a valid `HEX_API_TOKEN` to be defined in the current environment,
while self-hosted repositories can use a range of various authentication methods.

Check out the [hex documenation on self-hosting](https://hex.pm/docs/self_hosting)
to learn how to maintain a private package registry.

## Prerequisites

Expublish expects `git` and `mix` to be available at runtime but comes without any additional dependencies.
