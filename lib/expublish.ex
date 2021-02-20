defmodule Expublish do
  @moduledoc """
  Main module putting everything together:

  ```
  def major do
    Tests.run!()

    "major"
    |> Semver.update_version!()
    |> Changelog.write_entry!(DateTime.utc_now())
    |> Git.add_commit_and_tag()

    Publish.run!()
  end
  ```
  """

  alias Expublish.Changelog
  alias Expublish.Git
  alias Expublish.Publish
  alias Expublish.Semver
  alias Expublish.Tests

  require Logger

  @doc """
  Publish major version of current project.
  """
  def major, do: run("major")

  @doc """
  Publish minor version of current project.
  """
  def minor, do: run("minor")

  @doc """
  Publish patch version of current project.
  """
  def patch, do: run("patch")

  defp run(semver) do
    if (!Git.porcelain?()), do: message_and_stop("Working directory not clean: Stash or move untracked changes.")
    if (!File.exists?("RELEASE.md")), do: message_and_stop("Missing file: RELEASE.md")
    if (!File.exists?("CHANGELOG.md")), do: message_and_stop("Missing file: CHANGELOG.md")
    if (!Changelog.is_valid?()), do: message_and_stop("Invalid CHANGELOG.md. Check initial setup section in docs.")

    Tests.run!()

    new_version = semver
    |> Semver.update_version!()
    |> Changelog.write_entry!(DateTime.utc_now())
    |> Git.add_commit_and_tag()

    Changelog.remove_release_file!()
    Publish.run!()

    Logger.info("Success! Published new version: #{new_version}")
  end

  @doc false
  def message_and_stop(message) do
    Logger.error(message)
    exit(:shutdown)
  end
end

