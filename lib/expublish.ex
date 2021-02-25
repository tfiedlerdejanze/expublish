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
  alias Expublish.Options
  alias Expublish.Semver
  alias Expublish.Tests

  require Logger

  @doc """
  Publish major version of current project.
  """
  @spec major(Options.t()) :: :ok
  def major(options \\ %Options{}), do: run(:major, options)

  @doc """
  Publish minor version of current project.
  """
  @spec minor(Options.t()) :: :ok
  def minor(options \\ %Options{}), do: run(:minor, options)

  @doc """
  Publish patch version of current project.
  """
  @spec patch(Options.t()) :: :ok
  def patch(options \\ %Options{}), do: run(:patch, options)

  @spec run(:major | :minor | :patch, Options.t()) :: :ok
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

      :ok
    else
      error ->
        Logger.error(error)
        exit(:shutdown)
    end
  end

  defp finish(version, %Options{dry_run: true}) do
    Logger.info("Finished dry run for new package version: #{version}.")
  end

  defp finish(version, _options) do
    Logger.info("Finished release for new package version: #{version}.")
  end
end
