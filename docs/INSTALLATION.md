# Installation

1\. Add `:expublish` to your dev dependencies in `mix.exs`:

```elixir
{:expublish, "~> 2.3", only: [:dev]}
```

2\. Create a `CHANGELOG.md` in the root folder of your project. It must contain a placeholder:

```text
<!-- %% CHANGELOG_ENTRIES %% -->
```

3\. Do not keep track of the release file. Put the following line in your `.gitignore`:

```text
RELEASE.md
```

The file is deleted after every successful release.

## Prerequisites

Expublish expects `git` and `mix` to be available at runtime but comes without any additional dependencies.

## Note on hex authentication

Regardless of publishing to [hex.pm](https://hex.pm/) or a self-hosted hex repository,
the shell environment where `mix expublish` is being executed must authenticate for
the publishing step to succeed.

While publishing to hex.pm usually requires a valid `HEX_API_TOKEN` to be defined
in the current environment, self-hosted repositories can use a range of various authentication methods.

Check the hex documentation on [publishing](https://hex.pm/docs/publish) and
[self-hosting](https://hex.pm/docs/self_hosting) to find out more.

