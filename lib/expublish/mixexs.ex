defmodule Expublish.Mixexs do
  @moduledoc """
  Functions for reading and writing project mix.exs.
  """

  alias Expublish.Options

  require Logger

  @doc """
  Return parsed %Version{} from current mix project.
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
  Writes version to project mix.exs.
  """
  @spec update!(Version.t(), Options.t()) :: Version.t()
  def update!(new_version, options) do
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

    maybe_write_mixexs(options, replaced)

    new_version
  end

  defp version_pattern(:default, version) do
    "version: \"#{version}\""
  end

  defp version_pattern(:attribute, version) do
    "@version \"#{version}\""
  end

  defp maybe_write_mixexs(%Options{dry_run: true}, _contents) do
    Logger.info("Skipping new version in mix.exs.")
  end

  defp maybe_write_mixexs(_options, contents) do
    Logger.info("Writing new version to mix.exs.")

    File.write!("mix.exs", contents)
  end

  defp get_replace_mode(contents, version) do
    cond do
      contents =~ version_pattern(:attribute, version) -> :attribute
      contents =~ version_pattern(:default, version) -> :default
      true -> :default
    end
  end
end
