defmodule Expublish.Semver do
  @moduledoc """
  Functions for manipulating [%Version{}](https://hexdocs.pm/elixir/Version.html) and updating project mix.exs.
  """

  alias Expublish.Options

  require Logger

  @doc """
  Return parsed %Version{} from current mix project.
  """
  @spec get_version! :: Version.t()
  def get_version! do
    Mix.Project.config()[:version]
    |> Version.parse!()
  end

  @doc """
  Write given %Version{} to project mix.exs.
  """
  @spec set_version!(Version.t(), Options.t()) :: Version.t()
  def set_version!(new_version, options \\ %Options{}) do
    contents = File.read!("mix.exs")
    version = get_version!()

    replaced =
      String.replace(
        contents,
        version_pattern(version),
        version_pattern(new_version)
      )

    if contents == replaced do
      Logger.error("Could not update version in mix.exs.")
      exit(:shutdown)
    end

    maybe_write_mixexs(options, replaced)

    new_version
  end

  @doc """
  Update version in project mix.exs by given level.

  Reads the current version from mix.exs, increases it by given level
  and writes it back to mix.exs.  Level must be one of: `"major", "minor", "patch"`
  """
  @spec update_version!(:major | :minor | :patch, Options.t()) :: Version.t()
  def update_version!(level, options \\ %Options{})

  def update_version!(:major, options),
    do: get_version!() |> bump_major() |> set_version!(options)

  def update_version!(:minor, options),
    do: get_version!() |> bump_minor() |> set_version!(options)

  def update_version!(:patch, options),
    do: get_version!() |> bump_patch() |> set_version!(options)

  def update_version!(level, _options), do: raise("Invalid version level: #{level}")

  @doc "Bump major version."
  @spec bump_major(Version.t()) :: Version.t()
  def bump_major(%Version{} = version) do
    %{version | major: version.major + 1, minor: 0, patch: 0}
  end

  @doc "Bump minor version."
  @spec bump_minor(Version.t()) :: Version.t()
  def bump_minor(%Version{} = version) do
    %{version | minor: version.minor + 1, patch: 0}
  end

  @doc "Bump patch version."
  @spec bump_patch(Version.t()) :: Version.t()
  def bump_patch(%Version{} = version) do
    %{version | patch: version.patch + 1}
  end

  defp version_pattern(version) do
    "version: \"#{version}\""
  end

  defp maybe_write_mixexs(%{dry_run: true}, _contents) do
    Logger.info("Skipping new version in mix.exs.")
  end

  defp maybe_write_mixexs(_options, contents) do
    Logger.info("Writing new version to mix.exs.")

    File.write!("mix.exs", contents)
  end
end
