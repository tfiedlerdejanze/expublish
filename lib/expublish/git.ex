defmodule Expublish.Git do
  @moduledoc """
  Shell commands for git.
  """

  require Logger

  alias Expublish.Options

  @doc """
  Validate state of git working directory.

  Returns :ok or error message.
  """
  @spec validate(Options.t()) :: :ok | String.t()
  def validate(options \\ %Options{})

  def validate(%Options{allow_untracked: true}) do
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
  @spec commit_and_tag(Version.t(), Options.t()) :: Version.t()
  def commit_and_tag(%Version{} = version, options \\ %Options{}) do
    commit_prefix = Options.git_commit_prefix(options)
    tag_prefix = Options.git_tag_prefix(options)

    git_commit_message = "#{commit_prefix} #{version}"
    git_tag = "#{tag_prefix}#{version}"

    do_commit_and_tag(options, git_commit_message, git_tag)

    version
  end

  defp do_commit_and_tag(%{dry_run: true}, git_commit_message, git_tag) do
    Logger.info(~s'Skipping version commit: "#{git_commit_message}".')
    Logger.info(~s'Skipping version tag: "#{git_tag}".')
  end

  defp do_commit_and_tag(_options, git_commit_message, git_tag) do
    System.cmd("git", ["add", "."])

    Logger.info(~s'Creating new version commit: "#{git_commit_message}".')
    System.cmd("git", ["commit", "-qm", git_commit_message])

    Logger.info(~s'Creating new version tag: "#{git_tag}".')
    System.cmd("git", ["tag", "-a", git_tag, "-m", git_commit_message])
  end

  @doc """
  Git push to remote.
  """
  @spec push(Version.t(), %Options{}) :: Version.t()
  def push(version, options \\ %Options{})

  def push(%Version{} = version, %Options{
        dry_run: false,
        disable_push: false,
        branch: branch,
        remote: remote
      }) do
    Logger.info("Pushing new package version with: \"git push #{remote} #{branch} --tags\".\n")
    {_, error_code} = System.cmd("git", ["push", remote, branch, "--tags"])

    if error_code != 0 do
      Logger.error("Failed to push new version commit to git.")
    end

    version
  end

  def push(%Version{} = version, %Options{branch: branch, remote: remote}) do
    Logger.info("Skipping \"git push #{remote} #{branch} --tags\".")
    version
  end
end
