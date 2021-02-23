defmodule Expublish.Changelog do
  @moduledoc """
  Functions to manipulate CHANGELOG.md and RELEASE.md.
  """

  require Logger

  @release_filename "RELEASE.md"

  @changelog_filename "CHANGELOG.md"
  @changelog_header_prefix String.duplicate("#", 2)
  @changelog_entries_marker "<!-- %% CHANGELOG_ENTRIES %% -->"

  @doc """
  Validate changelog setup. Returns :ok or error message.
  """
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
  Removes RELEASE.md.
  """
  def remove_release_file!(%Version{} = version, %{dry_run: true}) do
    version
  end

  def remove_release_file!(%Version{} = version, _options) do
    File.rm!(@release_filename)
    version
  end

  @doc """
  Generate changelog entry from RELEASE.md contents.

  Writes entry to CHANGELOG.md for given %Version{} and %Datetime{}.
  """
  def write_entry!(%Version{} = version, %DateTime{} = date_time, options \\ %{}) do
    date_time_string =
      date_time
      |> DateTime.truncate(:second)
      |> Calendar.strftime("%d. %b %Y %H:%M")

    title = "#{version} - #{date_time_string}"
    text = File.read!(@release_filename) |> String.trim()

    add_changelog_entry(title, text, options)

    version
  end

  defp add_changelog_entry(title, _text, %{dry_run: true}) do
    Logger.info("Skipping new entry in CHANGELOG.md: #{title}")
  end

  defp add_changelog_entry(title, text, _options) do
    Logger.info("Adding new entry in CHANGELOG.md: #{title}")

    contents = File.read!(@changelog_filename)
    [first, last] = String.split(contents, @changelog_entries_marker)

    replaced =
      Enum.join([
        first,
        """
        #{@changelog_entries_marker}

        """,
        """
        #{@changelog_header_prefix} #{title}

        #{text}
        """,
        last
      ])

    File.write!(@changelog_filename, replaced)
  end
end
