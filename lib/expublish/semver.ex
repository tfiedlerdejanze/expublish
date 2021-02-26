defmodule Expublish.Semver do
  @moduledoc """
  Functions for manipulating [%Version{}](https://hexdocs.pm/elixir/Version.html) and updating project mix.exs.
  """

  @alpha "alpha"
  @beta "beta"
  @rc "rc"

  alias Expublish.Options

  require Logger

  @doc """
  Return parsed %Version{} from current mix project.
  """
  @spec get_version! :: Version.t()
  def get_version! do
    Mix.Project.config()[:version]
    |> Version.parse!()
  end

  @doc """
  Write given %Version{} to project mix.exs.
  """
  @spec set_version!(Version.t(), Options.t()) :: Version.t()
  def set_version!(new_version, options \\ %Options{}) do
    contents = File.read!("mix.exs")
    version = get_version!()

    replaced =
      String.replace(
        contents,
        version_pattern(version),
        version_pattern(new_version)
      )

    if contents == replaced do
      Logger.error("Could not update version in mix.exs.")
      exit(:shutdown)
    end

    maybe_write_mixexs(options, replaced)

    new_version
  end

  @doc """
  Increase version in project mix.exs by given level.

  Reads the current version from mix.exs, increases it by given level
  and writes it back to mix.exs.
  """
  @type level :: :major | :minor | :patch | :alpha | :beta | :rc | :stable
  @spec bump_version!(level, Options.t()) :: Version.t()
  def bump_version!(level, options \\ %Options{})

  def bump_version!(:major, options),
    do: get_version!() |> bump_major() |> set_version!(options)

  def bump_version!(:minor, options),
    do: get_version!() |> bump_minor() |> set_version!(options)

  def bump_version!(:patch, options),
    do: get_version!() |> bump_patch() |> set_version!(options)

  def bump_version!(:alpha, options),
    do: get_version!() |> alpha(options) |> set_version!(options)

  def bump_version!(:beta, options),
    do: get_version!() |> beta(options) |> set_version!(options)

  def bump_version!(:rc, options),
    do: get_version!() |> rc(options) |> set_version!(options)

  def bump_version!(:stable, options),
    do: get_version!() |> stable() |> set_version!(options)

  def bump_version!(level, _options), do: raise("Invalid version level: #{level}")

  @doc "Bump major version."
  @spec bump_major(Version.t()) :: Version.t()
  def bump_major(%Version{} = version) do
    %{version | major: version.major + 1, minor: 0, patch: 0}
  end

  @doc "Bump minor version."
  @spec bump_minor(Version.t()) :: Version.t()
  def bump_minor(%Version{} = version) do
    %{version | minor: version.minor + 1, patch: 0}
  end

  @doc "Bump patch version."
  @spec bump_patch(Version.t()) :: Version.t()
  def bump_patch(%Version{} = version) do
    %{version | patch: version.patch + 1}
  end

  @doc "Add alpha pre-release and bump patch version."
  @spec alpha(Version.t(), Options.t()) :: Version.t()
  def alpha(version, options \\ %Options{})

  def alpha(%Version{pre: [pre]} = version, _) when pre in ["beta", "rc"] do
    Logger.error("Can not create alpha version from current #{pre} pre-release: #{version}.")
    exit(:shutdown)
  end

  def alpha(%Version{} = version, %Options{as_major: true}) do
    %{bump_major(version) | pre: [@alpha]}
  end

  def alpha(%Version{} = version, %Options{as_minor: true}) do
    %{bump_minor(version) | pre: [@alpha]}
  end

  def alpha(%Version{} = version, _options) do
    %{bump_patch(version) | pre: [@alpha]}
  end

  @doc "Add beta pre-release and bump patch version."
  @spec beta(Version.t(), Options.t()) :: Version.t()
  def beta(version, options \\ %Options{})

  def beta(%Version{pre: [pre]} = version, _) when pre in ["rc"] do
    Logger.error("Can not create beta version from current #{pre} pre-release: #{version}.")
    exit(:shutdown)
  end

  def beta(%Version{} = version, %Options{as_major: true}) do
    %{bump_major(version) | pre: [@beta]}
  end

  def beta(%Version{} = version, %Options{as_minor: true}) do
    %{bump_minor(version) | pre: [@beta]}
  end

  def beta(%Version{} = version, _options) do
    %{bump_patch(version) | pre: [@beta]}
  end

  @doc "Add release-candidate pre-release and bump patch version."
  @spec rc(Version.t(), Options.t()) :: Version.t()
  def rc(version, options \\ %Options{})

  def rc(%Version{} = version, %Options{as_major: true}) do
    %{bump_major(version) | pre: [@rc]}
  end

  def rc(%Version{} = version, %Options{as_minor: true}) do
    %{bump_minor(version) | pre: [@rc]}
  end

  def rc(%Version{} = version, _options) do
    %{bump_patch(version) | pre: [@rc]}
  end

  def stable(%Version{pre: []} = version) do
    Logger.error("Can not release already stable version #{version}. Missing pre-release.")
    exit(:shutdown)
  end

  def stable(%Version{} = version) do
    %{version | pre: []}
  end

  defp version_pattern(version) do
    "version: \"#{version}\""
  end

  defp maybe_write_mixexs(%{dry_run: true}, _contents) do
    Logger.info("Skipping new version in mix.exs.")
  end

  defp maybe_write_mixexs(_options, contents) do
    Logger.info("Writing new version to mix.exs.")

    File.write!("mix.exs", contents)
  end
end
