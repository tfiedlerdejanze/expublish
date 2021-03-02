defmodule Expublish.Semver do
  @moduledoc """
  Functions for manipulating [%Version{}](https://hexdocs.pm/elixir/Version.html).
  """

  @alpha "alpha"
  @beta "beta"
  @rc "rc"

  alias Expublish.Options

  require Logger

  @type level() :: :major | :minor | :patch | :rc | :beta | :alpha | :stable
  @spec increase!(Version.t(), level(), Options.t()) :: Version.t()
  @doc "Interfaces `Expublish.Semver` version increase functions."
  def increase!(version, level, options \\ %Options{})

  def increase!(version, :major, _options), do: major(version)
  def increase!(version, :minor, _options), do: minor(version)
  def increase!(version, :patch, _options), do: patch(version)
  def increase!(version, :stable, _options), do: stable(version)
  def increase!(version, :rc, options), do: rc(version, options)
  def increase!(version, :beta, options), do: beta(version, options)
  def increase!(version, :alpha, options), do: alpha(version, options)

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

  @doc "Remove current pre-release suffix and declare current version stable."
  @spec stable(Version.t()) :: Version.t()
  def stable(%Version{pre: []} = version) do
    Logger.error("Can not create stable release from already stable version #{version}. Abort.")
    exit(:shutdown)
  end

  def stable(%Version{} = version) do
    %{version | pre: []}
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
end
