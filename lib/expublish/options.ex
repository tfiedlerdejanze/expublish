defmodule Expublish.Options do
  @moduledoc false

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

  def defaults, do: %{
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
    {options, _, _} =
      OptionParser.parse(args,
        aliases: @aliases,
        strict: @typed_options
      )

    options = Map.merge(defaults(), Enum.into(options, %{}))

    if print_help?(options) do
      print_help()
      exit(:shutdown)
    end

    options
  end

  def allow_untracked?(options), do: Map.get(options, :allow_untracked)
  def dry_run?(options), do: Map.get(options, :dry_run)
  def print_help?(options), do: Map.get(options, :help)
  def skip_publish?(options), do: Map.get(options, :disable_publish)
  def skip_push?(options), do: Map.get(options, :disable_push)
  def skip_tests?(options), do: Map.get(options, :disable_test)

  def git_branch(options), do: Map.get(options, :branch) |> sanitize()
  def git_remote(options), do: Map.get(options, :remote) |> sanitize()
  def git_tag_prefix(options), do: Map.get(options, :tag_prefix) |> sanitize()
  def git_commit_prefix(options), do: Map.get(options, :commit_prefix) |> sanitize()

  def print_help() do
    IO.puts(~S"""
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

  defp sanitize(string) do
    string
    |> String.replace("\"", "")
    |> String.replace("'", "")
    |> String.trim()
  end
end
