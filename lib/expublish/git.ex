defmodule Expublish.Git do
  @moduledoc """
  Shell commands for git.
  """

  require Logger

  alias Expublish.Options

  @doc """
  Validate state of git working directory. Returning :ok or error message.
  """
  def validate(options \\ []) do
    command =
      if Options.allow_untracked?(options),
        do: ["status", "--untracked-files=no", "--porcelain"],
        else: ["status", "--porcelain"]

    if {"", 0} == System.cmd("git", command),
      do: :ok,
      else: "Git working directory not clean."
  end

  @doc """
  Create a git commit and tag for given %Version{}.
  """
  def add_commit_and_tag(%Version{} = version, options \\ []) do
    if !Options.dry_run?(options) do
      Mix.Shell.IO.cmd("git add .", [])
      Mix.Shell.IO.cmd(~s'git commit -m "Version release #{version}"')
      Mix.Shell.IO.cmd(~s'git tag -a v#{version} -m "Version #{version}"')
    end

    version
  end

  @doc """
  Push to remote.
  """
  def push(%Version{} = version, options \\ []) do
    remote = Options.git_remote(options)
    branch = Options.git_branch(options)

    if !Options.dry_run?(options) && !Options.skip_push?(options) do
      error_code = Mix.Shell.IO.cmd("git push #{remote} #{branch} --tags", [])

      if error_code != 0 do
        Logger.error("Failed while pushing version commit to git.")
        exit(:shutdown)
      end
    end

    if Options.dry_run?(options) || Options.skip_push?(options) do
      Logger.info("Skipping \"git push #{remote} #{branch} --tags\".")
    end

    version
  end
end
