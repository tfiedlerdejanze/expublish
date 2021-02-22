defmodule Expublish.Options do
  @moduledoc false

  def parse(args) do
    {options, _, _} =
      OptionParser.parse(args,
        aliases: [
          h: :help,
          d: :dry_run
        ],
        strict: [
          branch: :string,
          dry_run: :boolean,
          help: :boolean,
          remote: :string,
          allow_untracked: :boolean,
          disable_publish: :boolean,
          disable_push: :boolean,
          disable_test: :boolean
        ]
      )

    if print_help?(options) do
      print_help()
      exit(:shutdown)
    end

    options
  end

  def allow_untracked?(options), do: Keyword.get(options, :allow_untracked, false)
  def print_help?(options), do: Keyword.get(options, :help, false)
  def dry_run?(options), do: Keyword.get(options, :dry_run, false)
  def skip_push?(options), do: Keyword.get(options, :disable_push, false)
  def skip_publish?(options), do: Keyword.get(options, :disable_publish, false)
  def skip_tests?(options), do: Keyword.get(options, :disable_test, false)

  def git_branch(options), do: Keyword.get(options, :branch, "master")
  def git_remote(options), do: Keyword.get(options, :remote, "origin")

  def print_help() do
    IO.puts(~S"""
    Usage: mix expublish.[level] [options]

    level:
      major - Publish major version
      minor - Publish minor version
      patch - Publish patch version

    options:
      -d, --dry-run       - Perform dry run (no writes, no commits)
      --branch=string     - Remote branch to push to, default: "master"
      --remote=string     - Remote name to push to, default: "origin"
      --allow-untracked   - Ignore untracked files while checking git working directory
      --disable-publish   - Disable hex publish
      --disable-push      - Disable git push
      --disable-test      - Disable test run
    """)
  end
end
