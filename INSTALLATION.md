# How to install

Add `:expublish` in mix.exs dev dependencies:

```elixir
{:expublish, "~> 1.0.0", only: [:dev]}
```

Create a `CHANGELOG.md` in the root folder of your project. It must contain a placeholder:

```text
<!-- %% CHANGELOG_ENTRIES %% -->
```

We dont want to track the release file. Add this line to your `.gitignore`:

```text
RELEASE.md
```
