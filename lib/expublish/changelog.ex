defmodule Expublish.Changelog do
  @moduledoc """
  Functions to manipulate CHANGELOG.md and RELEASE.md.
  """

  alias Expublish.Options

  require Logger

  @release_filename "RELEASE.md"

  @changelog_filename "CHANGELOG.md"
  @changelog_header_prefix String.duplicate("#", 2)
  @changelog_entries_marker "<!-- %% CHANGELOG_ENTRIES %% -->"

  @doc """
  Validate changelog setup. Returns :ok or error message.
  """
  @spec validate(Options.t()) :: :ok | String.t()
  def validate(_options) do
    cond do
      !File.exists?("RELEASE.md") ->
        "Missing file: RELEASE.md"

      !File.exists?("CHANGELOG.md") ->
        "Missing file: CHANGELOG.md"

      !String.contains?(
        File.read!(@changelog_filename),
        @changelog_entries_marker
      ) ->
        "CHANGELOG.md is missing required placeholder."

      true ->
        :ok
    end
  end

  @doc """
  Generate new changelog entry from RELEASE.md contents.
  """
  @spec write_entry!(Version.t(), DateTime.t(), Options.t()) :: Version.t()
  def write_entry!(%Version{} = version, %DateTime{} = date_time, options) do
    date_time_string =
      date_time
      |> DateTime.truncate(:second)
      |> Calendar.strftime("%d. %b %Y %H:%M")

    title = "#{@changelog_header_prefix} #{version} - #{date_time_string}"
    text = File.read!(@release_filename) |> String.trim()

    add_changelog_entry(title, text, options)

    version
  end

  @doc """
  Removes RELEASE.md.
  """
  @spec remove_release_file!(Version.t(), Options.t()) :: Version.t()
  def remove_release_file!(%Version{} = version, %Options{dry_run: true}) do
    version
  end

  def remove_release_file!(%Version{} = version, _options) do
    File.rm!(@release_filename)
    version
  end

  defp add_changelog_entry(title, text, %{dry_run: true} = options) do
    log_new_changelog_entry(title, text, options)
  end

  defp add_changelog_entry(title, text, options) do
    log_new_changelog_entry(title, text, options)

    contents = File.read!(@changelog_filename)
    [first, last] = String.split(contents, @changelog_entries_marker)

    replaced =
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

    File.write!(@changelog_filename, replaced)
  end

  defp log_new_changelog_entry(title, text, %{dry_run: true}) do
    entry = "\n\n#{title}\n\n#{text}"
    Logger.info("Skipping new entry in CHANGELOG.md:#{entry}")
  end

  defp log_new_changelog_entry(title, text, _options) do
    entry = "\n\n#{title}\n\n#{text}"
    Logger.info("Writing new entry in CHANGELOG.md:#{entry}")
  end
end
