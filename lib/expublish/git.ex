defmodule Expublish.Git do
  @moduledoc """
  Shell commands for git.
  """

  alias Expublish.Options

  require Logger

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
    commit_prefix = Options.git_commit_prefix(options)
    tag_prefix = Options.git_tag_prefix(options)

    git_commit_message = "#{commit_prefix} #{version}"
    git_tag = "#{tag_prefix}#{version}"

    add(["add", "-u"], options)
    commit(["commit", "-qm", git_commit_message], options)
    tag(["tag", "-a", git_tag, "-m", git_commit_message], options)

    version
  end

  @doc """
  Git push to remote.
  """
  @spec push(Version.t(), Options.t()) :: Version.t()
  def push(version, options \\ %Options{})

  def push(%Version{} = version, %Options{dry_run: false, disable_push: false} = options) do
    %{branch: branch, remote: remote} = options
    Logger.info("Pushing new package version with: \"git push #{remote} #{branch} --tags\".\n")

    case Expublish.System.cmd("git", ["push", remote, branch, "--tags"]) do
      {_, 0} ->
        :noop

      _ ->
        Logger.error("Failed to push new version commit to git.")
        exit({:shutdown, 1})
    end

    version
  end

  def push(%Version{} = version, %Options{branch: branch, remote: remote}) do
    Logger.info("Skipping \"git push #{remote} #{branch} --tags\".")
    version
  end

  def releasable_commits(_options) do
    case Elixir.System.cmd("git", ["describe", "--tags", "--abbrev=0"], stderr_to_stdout: true) do
      {tag, 0} ->
        case Expublish.System.cmd("git", ["log", "#{String.trim(tag)}..HEAD", "--oneline"]) do
          {"", 0} ->
            Logger.error("No commits to release since last tag: #{String.trim(tag)}. Abort.")
            exit({:shutdown, 1})

          {commits, 0} ->
            prepare(commits)
        end

      {_, _} ->
        case Expublish.System.cmd("git", ["log", "--oneline"]) do
          {"", 0} ->
            Logger.error("No commits to release. Abort.")
            exit({:shutdown, 1})

          {commits, 0} ->
            prepare(commits)
        end
    end
  end

  defp prepare(commits_string) do
    commits_string
    |> String.split("\n")
    |> Enum.map(fn commit ->
      commit
      |> String.trim()
      |> String.split(" ")
      |> List.delete_at(0)
      |> Enum.join(" ")
    end)
    |> Enum.reject(&(is_nil(&1) or &1 == ""))
  end

  defp add(command, %Options{dry_run: true}) do
    Expublish.System.cmd("git", command ++ ["--dry-run"])
  end

  defp add(command, _options) do
    Expublish.System.cmd("git", command)
  end

  defp commit([_, _, git_commit_message] = command, %Options{dry_run: true}) do
    Logger.info(~s'Skipping new version commit: "#{git_commit_message}".')
    Expublish.System.cmd("git", command ++ ["--dry-run"])
  end

  defp commit([_, _, git_commit_message] = command, _options) do
    Logger.info(~s'Creating new version commit: "#{git_commit_message}".')
    Expublish.System.cmd("git", command)
  end

  defp tag([_, _, git_tag | _], %Options{dry_run: true}) do
    Logger.info(~s'Skipping new version tag: "#{git_tag}".')
  end

  defp tag([_, _, git_tag | _] = command, _options) do
    Logger.info(~s'Creating new version tag: "#{git_tag}".')
    Expublish.System.cmd("git", command)
  end

  defp status(command) do
    case System.cmd("git", command) do
      {"", 0} -> :ok
      _ -> "Git working directory not clean."
    end
  end
end
