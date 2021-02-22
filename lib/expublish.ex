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
    with :ok <- Git.validate(options),
         :ok <- Changelog.validate(options) do
      if !Options.skip_tests?(options), do: Tests.run()

      level
      |> Semver.update_version!(options)
      |> Changelog.write_entry!(DateTime.utc_now(), options)
      |> Git.add_commit_and_tag(options)
      |> Git.push(options)
      |> Changelog.remove_release_file!(options)
      |> Publish.run(options)
    else
      error ->
        error_message = if is_binary(error), do: error, else: inspect(error)
        Logger.error(error_message)
        exit(:shutdown)
    end
  end
end
