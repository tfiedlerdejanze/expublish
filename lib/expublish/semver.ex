defmodule Expublish.Semver do
  @moduledoc """
  Functions for manipulating [%Version{}](https://hexdocs.pm/elixir/Version.html) and updating project mix.exs.
  """

  @doc """
  Update version in project mix.exs by given semver.

  Reads the current version from mix.exs, increases it and writes it back to mix.exs.
  Argument must be one of "major", "minor" or "patch".
  """
  def update_version!("major"), do: get_version() |> bump_major() |> set_version()
  def update_version!("minor"), do: get_version() |> bump_minor() |> set_version()
  def update_version!("patch"), do: get_version() |> bump_patch() |> set_version()
  def update_version!(semver), do: raise("Invalid version semver: #{semver}")

  @doc """
  Return parsed %Version{} from project mix.exs.
  """
  def get_version do
    Version.parse!(Mix.Project.config()[:version])
  end

  @doc """
  Write given %Version{} to project mix.exs.
  """
  def set_version(new_version) do
    contents = File.read!("mix.exs")

    replaced =
      String.replace(
        contents,
        version_pattern(get_version()),
        version_pattern(new_version)
      )

    if (contents == replaced), do: Expublish.message_and_stop("Could not update version in mix.exs")

    File.write!("mix.exs", replaced)

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
