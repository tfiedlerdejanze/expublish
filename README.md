[![Hex.pm](https://img.shields.io/hexpm/v/expublish)](https://hex.pm/packages/expublish)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs.pm-brightgreen)](https://hexdocs.pm/expublish)

# Expublish

Automated version and changelog management for elixir packages.


```
mix publish.(major|minor|patch)
```

The publish task gives following guarantees for every new release:

- Clean git working directory
- Passing tests
- Bumped version in mix.exs
- Decent changelog entry
- Git commit and tag
- Publish to hex

To publish a new package version:

1. Create a `RELEASE.md` containing the new changelog entry.
2. Run the publish mix task.
3. Push the created git commit and tag.

```
$ echo "- changelog entry one\n- changelog entry two" > RELEASE.md
$ mix publish.minor
$ git push origin master --tags
```

## Initial setup

Add `:expublish` in mix.exs dev dependencies:

```
{:expublish, "~> 1.0.0", only: [:dev]}
```

Create a `CHANGELOG.md` in the root folder of your project. It must contain a placeholder:

```
<!-- %% CHANGELOG_ENTRIES %% -->
```

We dont want to track the release file. Add this line to your `.gitignore`:

```
RELEASE.md
```
