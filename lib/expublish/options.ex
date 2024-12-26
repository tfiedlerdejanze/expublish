defmodule Expublish.Options do
  @moduledoc """
  Validate and parse mix task arguments.
  """

  require Logger

  @defaults %{
    allow_untracked: false,
    as_major: false,
    as_minor: false,
    changelog_date_time: false,
    disable_publish: false,
    disable_push: false,
    disable_test: false,
    dry_run: false,
    help: false,
    branch: "master",
    remote: "origin",
    tag_prefix: "v",
    commit_prefix: "Version release",
    version_file: "mix.exs"
  }

  @aliases [
    h: :help,
    d: :dry_run
  ]

  @invalid_as_option_levels [:stable, :major, :minor, :patch]

  @type t :: %__MODULE__{}

  defstruct Enum.to_list(@defaults)

  @doc """
  Default options used for every run.

  ```
  %Expublish.Options{
  #{Enum.map_join(@defaults, ",\n", fn {k, v} -> "  #{k}: #{inspect(v)}" end)}
  }
  ```
  """
  @spec defaults :: t()
  def defaults, do: struct(__MODULE__, @defaults)

  @doc """
  Parse mix task arguments and merge with default options.
  """
  @spec parse(list(String.t())) :: struct()
  def parse(args) do
    args
    |> OptionParser.parse(aliases: @aliases, strict: typed_options())
    |> process_options()
  end

  @doc """
  Validates options and level combinations.

  Returns :ok or error message.
  """
  @type level() :: :major | :minor | :patch | :rc | :beta | :alpha | :stable
  @spec validate(__MODULE__.t(), level()) :: :ok | String.t()
  def validate(%__MODULE__{as_major: true}, level) when level in @invalid_as_option_levels do
    "Invalid task invokation. Can not use --as-major for #{level} version increase."
  end

  def validate(%__MODULE__{as_minor: true}, level) when level in @invalid_as_option_levels do
    "Invalid task invokation. Can not use --as-minor for #{level} version increase."
  end

  def validate(_options, _level), do: :ok

  @doc """
  Print help to stdout.
  """
  @spec print_help() :: :ok
  def print_help do
    IO.puts(help_string())

    :ok
  end

  @doc false
  def print_help?(%{help: help}), do: help

  @doc false
  def git_tag_prefix(%{tag_prefix: tag_prefix}), do: sanitize(tag_prefix)

  @doc false
  def git_commit_prefix(%{commit_prefix: commit_prefix}), do: sanitize(commit_prefix)

  defp process_options({options, _, []}) do
    options = Map.merge(defaults(), Map.new(options))

    if print_help?(options) do
      print_help()
      exit(:shutdown)
    end

    options
  end

  defp process_options({_, _, errors}) do
    option = if length(errors) == 1, do: "option", else: "options"
    invalid_options = Enum.map_join(errors, ", ", fn {option, _} -> option end)

    Logger.error("Invalid #{option}: #{invalid_options}. Abort.")
    exit({:shutdown, 1})
  end

  defp sanitize(string) do
    string
    |> String.replace("\"", "")
    |> String.replace("'", "")
    |> String.trim()
  end

  defp typed_options do
    Enum.map(@defaults, fn {k, v} -> {k, to_option_type(v)} end)
  end

  defp to_option_type(default) when is_boolean(default), do: :boolean
  defp to_option_type(default) when is_binary(default), do: :string

  defp help_string do
    """
    Usage: mix expublish.[level] [options]

    level:
      major   - Publish next major version
      minor   - Publish next minor version
      patch   - Publish next patch version
      stable  - Publish current stable version from pre-release
      rc      - Publish release-candidate pre-release of next patch version
      beta    - Publish beta pre-release of next patch version
      alpha   - Publish alpha pre-release of next patch version

    options:
      -d, --dry-run           - Perform dry run (no writes, no commits)
      --allow-untracked       - Allow untracked files during release
      --as-major              - Only for pre-release level
      --as-minor              - Only for pre-release level
      --disable-publish       - Disable hex publish
      --disable-push          - Disable git push
      --disable-test          - Disable test run
      --changelog-date-time   - Use date-time instead of date in new changelog entry
      --branch=string         - Remote branch to push to, default: #{inspect(Map.get(@defaults, :branch))}
      --remote=string         - Remote name to push to, default: #{inspect(Map.get(@defaults, :remote))}
      --commit-prefix=string  - Custom commit prefix, default:  #{inspect(Map.get(@defaults, :commit_prefix))}
      --tag-prefix=string     - Custom tag prefix, default: #{inspect(Map.get(@defaults, :tag_prefix))}
      --version-file=string   - When working with a separate file version file
    """
  end
end
