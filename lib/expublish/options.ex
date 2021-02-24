defmodule Expublish.Options do
  @moduledoc false

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

  def defaults,
    do: %{
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

  def parse(args) do
    process_options(
      OptionParser.parse(args,
        aliases: @aliases,
        strict: @typed_options
      )
    )
  end

  def print_help?(options), do: Map.get(options, :help)
  def git_tag_prefix(options), do: Map.get(options, :tag_prefix) |> sanitize()
  def git_commit_prefix(options), do: Map.get(options, :commit_prefix) |> sanitize()

  def print_help do
    IO.puts("""
    Usage: mix expublish.[level] [options]

    level:
      major - Publish major version
      minor - Publish minor version
      patch - Publish patch version

    options:
      -d, --dry-run           - Perform dry run (no writes, no commits)
      --branch=string         - Remote branch to push to, default: "master"
      --remote=string         - Remote name to push to, default: "origin"
      --commit-prefix=string  - Custom commit prefix, default: "Version release"
      --tag-prefix=string     - Custom tag prefix, default: "v"
      --allow-untracked       - Ignore untracked files while checking git working directory
      --disable-publish       - Disable hex publish
      --disable-push          - Disable git push
      --disable-test          - Disable test run
    """)
  end

  defp process_options({options, _, []}) do
    options = Map.merge(defaults(), Enum.into(options, %{}))

    if print_help?(options) do
      print_help()
      exit(:shutdown)
    end

    options
  end

  defp process_options({_, _, errors}) do
    Logger.warn("Invalid mix task options: #{inspect(errors)}. Try mix expublish -h.")
    exit(:shutdown)
  end

  defp sanitize(string) do
    string
    |> String.replace("\"", "")
    |> String.replace("'", "")
    |> String.trim()
  end
end
