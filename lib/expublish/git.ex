defmodule Expublish.Git do
  @moduledoc """
  Shell commands for git.
  """

  @doc """
  Check state of git working directory. Returning true or false.
  """
  def porcelain? do
    {"", 0} == System.cmd("git", ["status", "--untracked-files=no", "--porcelain"])
  end

  @doc """
  Create a git commit and tag for given %Version{}.
  """
  def add_commit_and_tag(%Version{} = version) do
    Mix.Shell.IO.cmd("git add .", [])
    Mix.Shell.IO.cmd(~s'git commit -m "Version release #{version}"')
    Mix.Shell.IO.cmd(~s'git tag -a v#{version} -m "Version #{version}"')

    version
  end
end

