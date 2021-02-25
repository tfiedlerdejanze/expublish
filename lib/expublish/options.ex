defmodule Expublish.Options do
  @moduledoc """
  Validate and parse mix task arguments.
  """

  require Logger

  @remote "origin"
  @branch "master"
  @commit "Version release"
  @tag "v"

  @typed_options [
    allow_untracked: :boolean,
    disable_publish: :boolean,
    disable_push: :boolean,
    disable_test: :boolean,
    dry_run: :boolean,
    help: :boolean,
    branch: :string,
    remote: :string,
    tag_prefix: :string,
    commit_prefix: :string
  ]

  @aliases [
    h: :help,
    d: :dry_run
  ]

  @defaults %{
    allow_untracked: false,
    disable_publish: false,
    disable_push: false,
    disable_test: false,
    dry_run: false,
    help: false,
    branch: @branch,
    remote: @remote,
    tag_prefix: @tag,
    commit_prefix: @commit
  }

  @doc """
  Default options used for every run.

  #{inspect(@defaults)}
  """
  def defaults,
    do: @defaults

  @doc """
  Parse list of mix task arguments
  """
  def parse(args) do
    process_options(
      OptionParser.parse(args,
        aliases: @aliases,
        strict: @typed_options
      )
    )
  end

  @doc """
  Print help to stdout.
  """
  def print_help do
    IO.puts(help_string())
  end

  @doc false
  def print_help?(options), do: Map.get(options, :help)

  @doc false
  def git_tag_prefix(options), do: Map.get(options, :tag_prefix) |> sanitize()

  @doc false
  def git_commit_prefix(options), do: Map.get(options, :commit_prefix) |> sanitize()

  defp process_options({options, _, []}) do
    options = Map.merge(defaults(), Enum.into(options, %{}))

    if print_help?(options) do
      print_help()
      exit(:shutdown)
    end

    options
  end

  defp process_options({_, _, errors}) do
    option = if length(errors) == 1, do: "option", else: "options"
    invalid_options = errors |> Enum.map(fn {option, _} -> option end) |> Enum.join(", ")

    Logger.error("Invalid #{option}: #{invalid_options}. Abort.")
    exit(:shutdown)
  end

  defp sanitize(string) do
    string
    |> String.replace("\"", "")
    |> String.replace("'", "")
    |> String.trim()
  end

  defp help_string do
    """
    Usage: mix expublish.[level] [options]

    level:
      major - Publish major version
      minor - Publish minor version
      patch - Publish patch version

    options:
      -d, --dry-run           - Perform dry run (no writes, no commits)
      --allow-untracked       - Allow untracked files during release
      --disable-publish       - Disable hex publish
      --disable-push          - Disable git push
      --disable-test          - Disable test run
      --branch=string         - Remote branch to push to, default: "master"
      --remote=string         - Remote name to push to, default: "origin"
      --commit-prefix=string  - Custom commit prefix, default: "Version release"
      --tag-prefix=string     - Custom tag prefix, default: "v"
    """
  end
end
