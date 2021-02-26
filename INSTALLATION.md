## Installation

Add `:expublish` to your dev dependencies in `mix.exs`:

```elixir
{:expublish, "~> 2.3", only: [:dev]}
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
