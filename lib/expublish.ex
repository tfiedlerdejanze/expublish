defmodule Expublish do
  @moduledoc """
  Main module putting everything together:

  ```
  def major do
    Tests.run!()

    "major"
    |> Semver.update_version!()
    |> Changelog.write_entry!(DateTime.utc_now())
    |> Git.commit_and_tag()
    |> Git.push()
    |> Hex.publish()
  end
  ```
  """

  alias Expublish.Changelog
  alias Expublish.Git
  alias Expublish.Hex
  alias Expublish.Semver
  alias Expublish.Tests

  require Logger

  @doc """
  Publish major version of current project.
  """
  def major(options \\ %{}), do: run("major", options)

  @doc """
  Publish minor version of current project.
  """
  def minor(options \\ %{}), do: run("minor", options)

  @doc """
  Publish patch version of current project.
  """
  def patch(options \\ %{}), do: run("patch", options)

  defp run(level, options) do
    with :ok <- Git.validate(options),
         :ok <- Changelog.validate(options) do
      Tests.run(options)

      level
      |> Semver.update_version!(options)
      |> Changelog.write_entry!(DateTime.utc_now(), options)
      |> Git.commit_and_tag(options)
      |> Git.push(options)
      |> Changelog.remove_release_file!(options)
      |> Hex.publish(options)
      |> finish(options)
    else
      error ->
        error_message = if is_binary(error), do: error, else: inspect(error)
        Logger.error(error_message)
        exit(:shutdown)
    end
  end

  defp finish(version, %{dry_run: true}) do
    Logger.info("Finished dry run for new package version: #{version}.")
  end
  defp finish(version, _options) do
    Logger.info("Finished release for new package version: #{version}.")
  end
end
