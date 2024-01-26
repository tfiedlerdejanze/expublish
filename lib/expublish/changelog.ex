defmodule Expublish.Changelog do
  @moduledoc """
  Functions to manipulate CHANGELOG.md and RELEASE.md.
  """

  alias Expublish.Options

  require Logger

  @release_file "RELEASE.md"
  @changelog_file "CHANGELOG.md"
  @changelog_entries_marker "<!-- %% CHANGELOG_ENTRIES %% -->"

  @doc """
  Validate changelog setup. Returns :ok or error message.
  """
  @spec validate(Options.t()) :: :ok | String.t()
  def validate(_options) do
    cond do
      !File.exists?(@release_file) ->
        "Missing file: #{@release_file}"

      !File.exists?(@changelog_file) ->
        "Missing file: #{@changelog_file}"

      !String.contains?(File.read!(@changelog_file), @changelog_entries_marker) ->
        "CHANGELOG.md is missing required placeholder."

      true ->
        :ok
    end
  end

  @doc """
  Generate new changelog entry from RELEASE.md contents.
  """
  @spec write_entry!(Version.t(), Options.t()) :: Version.t()
  def write_entry!(%Version{} = version, options \\ %Options{}) do
    title = build_title(version, options)
    text = @release_file |> File.read!() |> String.trim()

    add_changelog_entry(title, text, options)

    version
  end

  @doc """
  Removes RELEASE.md.
  """
  @spec remove_release_file!(Version.t(), Options.t(), String.t()) :: Version.t()
  def remove_release_file!(version, options \\ %Options{}, file_path \\ @release_file)

  def remove_release_file!(%Version{} = version, %Options{dry_run: true}, _) do
    version
  end

  def remove_release_file!(%Version{} = version, _options, file_path) do
    File.rm!(file_path)
    version
  end

  @doc """
  Build changelog entry title with version and ISO 8601 date.

  Formats current or given `NaiveDateTime` to ISO 8601 date string.
  Can be changed to date-time representation with the `--changelog-date-time` option.
  """
  @spec build_title(Version.t(), Options.t(), nil | NaiveDateTime.t()) :: String.t()
  def build_title(version, options \\ %Options{}, date_time \\ nil)

  def build_title(version, options, nil) do
    build_title(version, options, NaiveDateTime.utc_now())
  end

  def build_title(version, %Options{changelog_date_time: true}, date_time) do
    date_time
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_iso8601()
    |> String.replace("T", " ")
    |> format_title(version)
  end

  def build_title(version, _options, date_time) do
    date_time
    |> Date.to_iso8601()
    |> format_title(version)
  end

  @doc false
  def with_new_entry(title, text) do
    contents = File.read!(@changelog_file)
    [first, last] = String.split(contents, @changelog_entries_marker)

    Enum.join([
      first,
      """
      #{@changelog_entries_marker}

      """,
      """
      #{title}

      #{text}
      """,
      last
    ])
  end

  defp add_changelog_entry(title, text, %Options{dry_run: true}) do
    Logger.info("Skipping new entry in CHANGELOG.md:#{format_entry(title, text)}")
  end

  defp add_changelog_entry(title, text, _options) do
    Logger.info("Writing new entry in CHANGELOG.md:#{format_entry(title, text)}")
    File.write!(@changelog_file, with_new_entry(title, text))
  end

  defp format_title(date_string, version) do
    "## #{version} - #{date_string}"
  end

  defp format_entry(title, text) do
    "\n\n#{title}\n\n#{text}"
  end
end
