defmodule Expublish.Changelog do
  @moduledoc """
  Functions to manipulate CHANGELOG.md and RELEASE.md.
  """

  require Logger

  alias Expublish.Options

  @release_filename "RELEASE.md"

  @changelog_filename "CHANGELOG.md"
  @changelog_header_prefix String.duplicate("#", 2)
  @changelog_entries_marker "<!-- %% CHANGELOG_ENTRIES %% -->"

  @doc """
  Removes RELEASE.md.
  """
  def remove_release_file! do
    File.rm!(@release_filename)
  end

  @doc """
  Generate changelog entry from RELEASE.md contents.

  Writes entry to CHANGELOG.md for given %Version{} and %Datetime{}.
  """
  def write_entry!(%Version{} = version, %DateTime{} = date_time, options \\ []) do
    date_time_string =
      date_time
      |> DateTime.truncate(:second)
      |> Calendar.strftime("%d. %b %Y %H:%M")

    title = "#{@changelog_header_prefix} #{version} - #{date_time_string}"
    text = File.read!(@release_filename) |> String.trim()

    if !Options.dry_run?(options) do
      add_changelog_entry(title, text)
      Logger.info("Wrote CHANGELOG.md entry")
    end

    version
  end

  @doc """
  Checks if #{@changelog_filename} contains valid placeholder.
  """
  def is_valid? do
    String.contains?(
      File.read!(@changelog_filename),
      @changelog_entries_marker
    )
  end

  defp add_changelog_entry(title, text) do
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
end
