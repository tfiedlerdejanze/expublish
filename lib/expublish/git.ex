defmodule Expublish.Git do
  @moduledoc """
  Shell commands for git.
  """

  require Logger

  alias Expublish.Options

  @doc """
  Validate state of git working directory. Returning :ok or error message.
  """
  def validate(%{allow_untracked: true}) do
    git_status(["status", "--untracked-files=no", "--porcelain"])
  end

  def validate(_options) do
    git_status(["status", "--porcelain"])
  end

  defp git_status(command) do
    if {"", 0} == System.cmd("git", command),
      do: :ok,
      else: "Git working directory not clean."
  end

  @doc """
  Create a git commit and tag for given %Version{}.
  """
  def commit_and_tag(%Version{} = version, options \\ %{}) do
    commit_prefix = Options.git_commit_prefix(options)
    tag_prefix = Options.git_tag_prefix(options)

    git_commit_message = "#{commit_prefix} #{version}"
    git_tag = "#{tag_prefix}#{version}"

    do_commit_and_tag(options, git_commit_message, git_tag, version)

    version
  end

  defp do_commit_and_tag(%{dry_run: true}, git_commit_message, git_tag, _version) do
    Logger.info(~s'Skipping version commit: "#{git_commit_message}".')
    Logger.info(~s'Skipping version tag: "#{git_tag}".')
  end

  defp do_commit_and_tag(_options, git_commit_message, git_tag, version) do
    Mix.Shell.IO.cmd("git add .")
    Mix.Shell.IO.cmd(~s'git commit -m "#{git_commit_message}"')
    Logger.info(~s'Created version commit: "#{git_commit_message}".')

    Mix.Shell.IO.cmd(~s'git tag -a #{git_tag} -m "Version #{version}"')
    Logger.info(~s'Created version tag: "#{git_tag}".')
  end

  @doc """
  Push to remote.
  """
  def push(version, %{dry_run: false, disable_push: false, branch: branch, remote: remote}) do
    error_code = Mix.Shell.IO.cmd("git push #{remote} #{branch} --tags", [])

    if error_code != 0 do
      Logger.error("Failed to push new version commit to git.")
    end

    version
  end

  def push(version, %{dry_run: true, branch: branch, remote: remote}) do
    Logger.info("Skipping \"git push #{remote} #{branch} --tags\".")
    version
  end

  def push(version, %{disable_push: true, branch: branch, remote: remote}) do
    Logger.info("Skipping \"git push #{remote} #{branch} --tags\".")
    version
  end
end
