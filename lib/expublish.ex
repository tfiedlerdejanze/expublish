defmodule Expublish do
  @moduledoc """
  Main module putting everything together:

  ```
  def major do
    Tests.run!()

    :major
    |> Semver.update_mix_exs!()
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

  @doc """
  Publish alpha version of current project.
  """
  @spec alpha(Options.t()) :: :ok
  def alpha(options \\ %Options{}), do: run(:alpha, options)

  @doc """
  Publish beta version of current project.
  """
  @spec beta(Options.t()) :: :ok
  def beta(options \\ %Options{}), do: run(:beta, options)

  @doc """
  Publish release-candidate version of current project.
  """
  @spec rc(Options.t()) :: :ok
  def rc(options \\ %Options{}), do: run(:rc, options)

  @doc """
  Removes pre-release and publish version of current project.
  """
  @spec stable(Options.t()) :: :ok
  def stable(options \\ %Options{}), do: run(:stable, options)

  @type level :: :major | :minor | :patch | :alpha | :beta | :rc | :stable
  @spec run(level, Options.t()) :: :ok

  defp run(level, options) do
    with :ok <- Git.validate(options),
         :ok <- Options.validate(options, level),
         :ok <- Changelog.validate(options) do
      level
      |> Tests.run(options)
      |> Semver.update_mix_exs!(options)
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
