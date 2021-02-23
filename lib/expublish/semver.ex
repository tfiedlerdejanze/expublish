defmodule Expublish.Semver do
  @moduledoc """
  Functions for manipulating [%Version{}](https://hexdocs.pm/elixir/Version.html) and updating project mix.exs.
  """

  require Logger

  @doc """
  Update version in project mix.exs by given level.

  Reads the current version from mix.exs, increases it and writes it back to mix.exs.
  Level must be one of "major", "minor" or "patch".
  """
  def update_version!(level, options \\ %{})

  def update_version!("major", options),
    do: get_version!() |> bump_major() |> set_version!(options)

  def update_version!("minor", options),
    do: get_version!() |> bump_minor() |> set_version!(options)

  def update_version!("patch", options),
    do: get_version!() |> bump_patch() |> set_version!(options)

  def update_version!(level, _options), do: raise("Invalid version level: #{level}")

  @doc """
  Return parsed %Version{} from project mix.exs.
  """
  def get_version! do
    Mix.Project.config()[:version]
    |> Version.parse!()
  end

  @doc """
  Write given %Version{} to project mix.exs.
  """
  def set_version!(new_version, options \\ []) do
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

  def bump_major(%Version{} = version) do
    %{version | major: version.major + 1, minor: 0, patch: 0}
  end

  def bump_minor(%Version{} = version) do
    %{version | minor: version.minor + 1, patch: 0}
  end

  def bump_patch(%Version{} = version) do
    %{version | patch: version.patch + 1}
  end

  def version_pattern(version) do
    "version: \"#{version}\""
  end

  defp maybe_write_mixexs(%{dry_run: true}, _contents), do: :noop
  defp maybe_write_mixexs(_options, contents), do: File.write!("mix.exs", contents)
end
