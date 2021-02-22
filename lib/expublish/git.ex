defmodule Expublish.Git do
  @moduledoc """
  Shell commands for git.
  """

  alias Expublish.Options

  @doc """
  Check state of git working directory. Returning true or false.
  """
  def porcelain?(options \\ []) do
    command =
      if Options.allow_untracked?(options),
        do: ["status", "--untracked-files=no", "--porcelain"],
        else: ["status", "--porcelain"]

    {"", 0} == System.cmd("git", command)
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
    if !Options.dry_run?(options) && !Options.skip_push?(options) do
      remote = Options.git_remote(options)
      branch = Options.git_branch(options)
      Mix.Shell.IO.cmd("git push #{remote} #{branch} --tags", [])
    end

    version
  end
end
