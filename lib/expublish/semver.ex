defmodule Expublish.Semver do
  @moduledoc """
  Functions for manipulating [%Version{}](https://hexdocs.pm/elixir/Version.html) and updating project mix.exs.
  """

  alias Expublish.Options

  @doc """
  Update version in project mix.exs by given level.

  Reads the current version from mix.exs, increases it and writes it back to mix.exs.
  Level must be one of "major", "minor" or "patch".

  """
  def update_version!(level, options \\ [])
  def update_version!("major", options), do: get_version() |> bump_major() |> set_version(options)
  def update_version!("minor", options), do: get_version() |> bump_minor() |> set_version(options)
  def update_version!("patch", options), do: get_version() |> bump_patch() |> set_version(options)
  def update_version!(level, _options), do: raise("Invalid version level: #{level}")

  @doc """
  Return parsed %Version{} from project mix.exs.
  """
  def get_version do
    Version.parse!(Mix.Project.config()[:version])
  end

  @doc """
  Write given %Version{} to project mix.exs.
  """
  def set_version(new_version, options \\ []) do
    contents = File.read!("mix.exs")

    replaced =
      String.replace(
        contents,
        version_pattern(get_version()),
        version_pattern(new_version)
      )

    if (contents == replaced), do: Expublish.message_and_stop("Could not update version in mix.exs")

    if (!Options.dry_run?(options)) do
      File.write!("mix.exs", replaced)
    end

    new_version
  end

  def version_pattern(version) do
    "version: \"#{version}\""
  end

  defp bump_major(%Version{} = version) do
    %{version | major: version.major + 1, minor: 0, patch: 0}
  end

  defp bump_minor(%Version{} = version) do
    %{version | minor: version.minor + 1, patch: 0}
  end

  defp bump_patch(%Version{} = version) do
    %{version | patch: version.patch + 1}
  end
end
