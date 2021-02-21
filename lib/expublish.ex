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
  alias Expublish.Options
  alias Expublish.Git
  alias Expublish.Publish
  alias Expublish.Semver
  alias Expublish.Tests

  require Logger

  @doc """
  Publish major version of current project.
  """
  def major(options \\ []), do: run("major", options)

  @doc """
  Publish minor version of current project.
  """
  def minor(options \\ []), do: run("minor", options)

  @doc """
  Publish patch version of current project.
  """
  def patch(options \\ []), do: run("patch", options)

  defp run(level, options) do
    if (!Git.porcelain?()), do: message_and_stop("Working directory not clean: Stash or move untracked changes.")
    if (!File.exists?("RELEASE.md")), do: message_and_stop("Missing file: RELEASE.md")
    if (!File.exists?("CHANGELOG.md")), do: message_and_stop("Missing file: CHANGELOG.md")
    if (!Changelog.is_valid?()), do: message_and_stop("Invalid CHANGELOG.md. Check the install guide.")

    if (!Options.skip_tests?(options)), do: Tests.run()

    new_version = level
    |> Semver.update_version!(options)
    |> Changelog.write_entry!(DateTime.utc_now(), options)
    |> Git.add_commit_and_tag(options)
    |> Git.push(options)

    if (!Options.dry_run?(options)) do
      Changelog.remove_release_file!()
      Publish.run()
    end

    Logger.info("Success! Published new version: #{new_version}")
  end

  @doc false
  def message_and_stop(message) do
    Logger.error(message)
    exit(:shutdown)
  end
end

