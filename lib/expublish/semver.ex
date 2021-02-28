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
  Increase version in project mix.exs by given level.

  Reads the current version from mix.exs, increases it by given level
  and writes it back to mix.exs.
  """
  @type level() :: :major | :minor | :patch | :rc | :beta | :alpha | :stable
  @spec update_mix_exs!(level(), Options.t()) :: Version.t()
  def update_mix_exs!(level, options \\ %Options{})

  def update_mix_exs!(:major, options),
    do: get_version!() |> major() |> set_version!(options)

  def update_mix_exs!(:minor, options),
    do: get_version!() |> minor() |> set_version!(options)

  def update_mix_exs!(:patch, options),
    do: get_version!() |> patch() |> set_version!(options)

  def update_mix_exs!(:alpha, options),
    do: get_version!() |> alpha(options) |> set_version!(options)

  def update_mix_exs!(:beta, options),
    do: get_version!() |> beta(options) |> set_version!(options)

  def update_mix_exs!(:rc, options),
    do: get_version!() |> rc(options) |> set_version!(options)

  def update_mix_exs!(:stable, options),
    do: get_version!() |> stable() |> set_version!(options)

  def update_mix_exs!(level, _options), do: raise("Invalid version level: #{level}")

  @doc "Bump alpha pre-release and patch version."
  @spec alpha(Version.t(), Options.t()) :: Version.t()
  def alpha(version, options \\ %Options{})

  def alpha(%Version{pre: [pre]} = version, _) when pre in [@beta, @rc] do
    Logger.error("Can not create alpha version from current #{pre} pre-release: #{version}.")
    exit(:shutdown)
  end

  def alpha(%Version{} = version, %Options{as_major: true}) do
    %{major(version) | pre: [@alpha]}
  end

  def alpha(%Version{} = version, %Options{as_minor: true}) do
    %{minor(version) | pre: [@alpha]}
  end

  def alpha(%Version{} = version, _options) do
    %{patch(version) | pre: [@alpha]}
  end

  @doc "Bump beta pre-release and patch version."
  @spec beta(Version.t(), Options.t()) :: Version.t()
  def beta(version, options \\ %Options{})

  def beta(%Version{pre: [pre]} = version, _) when pre in [@rc] do
    Logger.error("Can not create beta version from current #{pre} pre-release: #{version}.")
    exit(:shutdown)
  end

  def beta(%Version{} = version, %Options{as_major: true}) do
    %{major(version) | pre: [@beta]}
  end

  def beta(%Version{} = version, %Options{as_minor: true}) do
    %{minor(version) | pre: [@beta]}
  end

  def beta(%Version{pre: [@alpha]} = version, _) do
    %{version | pre: [@beta]}
  end

  def beta(%Version{} = version, _options) do
    %{patch(version) | pre: [@beta]}
  end

  @doc "Bump major version."
  @spec major(Version.t()) :: Version.t()
  def major(%Version{} = version) do
    %{version | major: version.major + 1, minor: 0, patch: 0}
  end

  @doc "Bump minor version."
  @spec minor(Version.t()) :: Version.t()
  def minor(%Version{} = version) do
    %{version | minor: version.minor + 1, patch: 0}
  end

  @doc "Bump patch version."
  @spec patch(Version.t()) :: Version.t()
  def patch(%Version{} = version) do
    %{version | patch: version.patch + 1}
  end

  @doc "Bump release-candidate pre-release and patch version."
  @spec rc(Version.t(), Options.t()) :: Version.t()
  def rc(version, options \\ %Options{})

  def rc(%Version{} = version, %Options{as_major: true}) do
    %{major(version) | pre: [@rc]}
  end

  def rc(%Version{} = version, %Options{as_minor: true}) do
    %{minor(version) | pre: [@rc]}
  end

  def rc(%Version{pre: [pre]} = version, _options) when pre in [@alpha, @beta] do
    %{version | pre: [@rc]}
  end

  def rc(%Version{} = version, _options) do
    %{patch(version) | pre: [@rc]}
  end

  @doc "Remove current pre-release suffix and declare current version stable."
  @spec stable(Version.t()) :: Version.t()
  def stable(%Version{pre: []} = version) do
    Logger.error("Can not create stable release from already stable version #{version}. Abort.")
    exit(:shutdown)
  end

  def stable(%Version{} = version) do
    %{version | pre: []}
  end

  defp version_pattern(version) do
    "version: \"#{version}\""
  end

  defp set_version!(new_version, options) do
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

  defp maybe_write_mixexs(%Options{dry_run: true}, _contents) do
    Logger.info("Skipping new version in mix.exs.")
  end

  defp maybe_write_mixexs(_options, contents) do
    Logger.info("Writing new version to mix.exs.")

    File.write!("mix.exs", contents)
  end
end
