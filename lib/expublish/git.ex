defmodule Expublish.Git do
  @moduledoc """
  Shell commands for git.
  """

  require Logger

  alias Expublish.Options

  @doc """
  Check state of git working directory. Returning true or false.
  """
  def porcelain? do
    {"", 0} == System.cmd("git", ["status", "--untracked-files=no", "--porcelain"])
  end

  @doc """
  Create a git commit and tag for given %Version{}.
  """
  def add_commit_and_tag(%Version{} = version, options \\ []) do
    if !Options.dry_run?(options) do
      Mix.Shell.IO.cmd("git add .", [])
      Mix.Shell.IO.cmd(~s'git commit -m "Version release #{version}"')
      Mix.Shell.IO.cmd(~s'git tag -a v#{version} -m "Version #{version}"')

      Logger.info("Created git tag v#{version}")
    end

    version
  end

  @doc """
  Push to remote.
  """
  def push(%Version{} = version, options \\ []) do
    if !Options.skip_push?(options) do
      remote = Keyword.get(options, :remote, "origin")
      branch = Keyword.get(options, :branch, "master")

      if !Options.dry_run?(options) do
        Mix.Shell.IO.cmd("git push #{remote} #{branch} --tags", [])
        Logger.info("New version pushed. remote: #{remote}, branch: #{branch}")
      end
    end

    version
  end
end
