defmodule Expublish.Project do
  @moduledoc """
  Functions for reading and writing project mix.exs.
  """

  alias Expublish.Options

  require Logger

  @doc """
  Return parsed %Version{} from current mix project.

  Reads from `Mix.Project.config/0`
  """
  @spec get_version!(Options.t()) :: Version.t()
  def get_version!(_options \\ %Options{}) do
    Mix.Project.config()[:version]
    |> Version.parse()
    |> case do
      {:ok, version} ->
        version

      _ ->
        Logger.error("Could not read current package version.")
        exit(:shutdown)
    end
  end

  @doc """
  Writes version to project mix.exs or given --version-file.
  """
  @spec update_version!(Version.t(), Options.t()) :: Version.t()
  def update_version!(new_version, options \\ %Options{})

  def update_version!(new_version, %Options{version_file: "mix.exs"} = options) do
    contents = File.read!("mix.exs")
    version = get_version!()

    replace_mode = get_replace_mode(contents, version)

    replaced =
      String.replace(
        contents,
        version_pattern(replace_mode, version),
        version_pattern(replace_mode, new_version)
      )

    if contents == replaced do
      Logger.error("Could not update version in mix.exs.")
      exit(:shutdown)
    end

    maybe_write_new_version("mix.exs", options, replaced)

    new_version
  end

  def update_version!(new_version, %Options{version_file: version_file} = options) do
    with true <- File.exists?(version_file),
         version <- File.read!(version_file),
         version <- String.trim(version),
         {:ok, version} <- Version.parse(version),
         :gt <- Version.compare(new_version, version) do
      maybe_write_new_version(version_file, options, "#{new_version}")
    else
      compare when compare in [:eq, :lt] ->
        Logger.error("Version in --version-file is higher or equal to mix project version.")
        exit(:shutdown)

      _ ->
        Logger.error("--version-file does not exist or contains invalid version.")
        exit(:shutdown)
    end

    new_version
  end

  defp version_pattern(:default, version) do
    "version: \"#{version}\""
  end

  defp version_pattern(:attribute, version) do
    "@version \"#{version}\""
  end

  defp maybe_write_new_version(file, %Options{dry_run: true}, _contents) do
    Logger.info("Skipping new version in #{file}.")
  end

  defp maybe_write_new_version(file, _options, contents) do
    Logger.info("Writing new version to #{file}.")

    File.write!(file, contents)
  end

  defp get_replace_mode(contents, version) do
    cond do
      contents =~ version_pattern(:attribute, version) -> :attribute
      contents =~ version_pattern(:default, version) -> :default
      true -> :default
    end
  end
end
