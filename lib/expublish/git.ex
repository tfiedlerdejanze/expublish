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
    status(["status", "--untracked-files=no", "--porcelain"])
  end

  def validate(_options) do
    status(["status", "--porcelain"])
  end

  @doc """
  Create a git commit and tag for given %Version{}.
  """
  @spec commit_and_tag(Version.t(), Options.t()) :: Version.t()
  def commit_and_tag(%Version{} = version, options \\ %Options{}) do
    syscall_module = if Mix.env() == :test, do: TestSystem, else: System

    commit_prefix = Options.git_commit_prefix(options)
    tag_prefix = Options.git_tag_prefix(options)

    git_commit_message = "#{commit_prefix} #{version}"
    git_tag = "#{tag_prefix}#{version}"

    add(["add", "-u"], options, syscall_module)
    commit(["commit", "-qm", git_commit_message], options, syscall_module)
    tag(["tag", "-a", git_tag, "-m", git_commit_message], options, syscall_module)

    version
  end

  @doc """
  Git push to remote.
  """
  @spec push(Version.t(), %Options{}) :: Version.t()
  def push(version, options \\ %Options{})

  def push(%Version{} = version, %Options{dry_run: false, disable_push: false} = options) do
    syscall_module = if Mix.env() == :test, do: TestSystem, else: System

    %{branch: branch, remote: remote} = options
    Logger.info("Pushing new package version with: \"git push #{remote} #{branch} --tags\".\n")

    case syscall_module.cmd("git", ["push", remote, branch, "--tags"]) do
      {_, 0} -> :noop
      _ -> Logger.error("Failed to push new version commit to git.")
    end

    version
  end

  def push(%Version{} = version, %Options{branch: branch, remote: remote}) do
    Logger.info("Skipping \"git push #{remote} #{branch} --tags\".")
    version
  end

  defp add(command, %Options{dry_run: true}, syscall_module) do
    syscall_module.cmd("git", command ++ ["--dry-run"])
  end

  defp add(command, _options, syscall_module) do
    syscall_module.cmd("git", command)
  end

  defp commit([_, _, git_commit_message] = command, %Options{dry_run: true}, syscall_module) do
    Logger.info(~s'Skipping new version commit: "#{git_commit_message}".')
    syscall_module.cmd("git", command ++ ["--dry-run"])
  end

  defp commit([_, _, git_commit_message] = command, _options, syscall_module) do
    Logger.info(~s'Creating new version commit: "#{git_commit_message}".')
    syscall_module.cmd("git", command)
  end

  defp tag([_, _, git_tag | _], %Options{dry_run: true}, _syscall_module) do
    Logger.info(~s'Skipping new version tag: "#{git_tag}".')
  end

  defp tag([_, _, git_tag | _] = command, _options, syscall_module) do
    Logger.info(~s'Creating new version tag: "#{git_tag}".')
    syscall_module.cmd("git", command)
  end

  defp status(command) do
    case System.cmd("git", command) do
      {"", 0} -> :ok
      _ -> "Git working directory not clean."
    end
  end
end
