defmodule SemverTest do
  use ExUnit.Case
  doctest Expublish

  import ExUnit.CaptureLog
  alias Expublish.Options
  alias Expublish.Semver

  @version %Version{major: 1, minor: 0, patch: 1}

  setup do
    [options: Options.parse(["--dry-run"]), version: @version]
  end

  test "get_version!/0 reads current project version from mix" do
    version = Semver.get_version!()
    expected = Mix.Project.config()[:version] |> Version.parse!()

    assert expected == version
  end

  test "major/1 increases major level of version", %{version: version} do
    expected = %Version{major: version.major + 1, minor: 0, patch: 0}

    assert Semver.major(version) == expected
  end

  test "minor/1 increases minor level of version", %{version: version} do
    expected = %Version{major: version.major, minor: version.minor + 1, patch: 0}

    assert Semver.minor(version) == expected
  end

  test "patch/1 increases patch level of version", %{version: version} do
    expected = %Version{major: version.major, minor: version.minor, patch: version.patch + 1}

    assert Semver.patch(version) == expected
  end

  ### alpha

  test "alpha/1 increases patch version and adds alpha pre-release", %{
    version: version,
    options: options
  } do
    expected = %Version{
      major: version.major,
      minor: version.minor,
      patch: version.patch + 1,
      pre: ["alpha"]
    }

    assert Semver.alpha(version, options) == expected
  end

  test "alpha/1 increases minor version and appends alpha pre-release", %{
    version: version,
    options: options
  } do
    expected = %Version{
      major: version.major,
      minor: version.minor + 1,
      patch: 0,
      pre: ["alpha"]
    }

    options = Map.merge(options, %{as_minor: true})

    assert Semver.alpha(version, options) == expected
  end

  test "alpha/1 increases major version and appends alpha pre-release", %{
    version: version,
    options: options
  } do
    expected = %Version{
      major: version.major + 1,
      minor: 0,
      patch: 0,
      pre: ["alpha"]
    }
    options = Map.merge(options, %{as_major: true})

    assert Semver.alpha(version, options) == expected
  end

  test "alpha/1 stops and logs an error when used with incompatible current pre-release", %{
    version: version,
    options: options
  } do
    v1 = %{version | pre: ["beta"]}

    fun1 = fn ->
      assert catch_exit(Semver.alpha(v1, options)) == :shutdown
    end

    v2 = %{version | pre: ["rc"]}

    fun2 = fn ->
      assert catch_exit(Semver.alpha(v2, options)) == :shutdown
    end

    assert capture_log(fun1) =~ "Can not create alpha"
    assert capture_log(fun1) =~ "#{version}"

    assert capture_log(fun2) =~ "Can not create alpha"
    assert capture_log(fun2) =~ "#{version}"
  end

  ### beta

  test "beta/1 increases patch version and adds beta pre-release", %{
    version: version,
    options: options
  } do
    expected = %Version{
      major: version.major,
      minor: version.minor,
      patch: version.patch + 1,
      pre: ["beta"]
    }

    assert Semver.beta(version, options) == expected
  end

  test "beta/1 increases minor version and appends beta pre-release", %{
    version: version,
    options: options
  } do
    expected = %Version{
      major: version.major,
      minor: version.minor + 1,
      patch: 0,
      pre: ["beta"]
    }

    options = Map.merge(options, %{as_minor: true})

    assert Semver.beta(version, options) == expected
  end

  test "beta/1 increases major version and appends beta pre-release", %{
    version: version,
    options: options
  } do
    expected = %Version{
      major: version.major + 1,
      minor: 0,
      patch: 0,
      pre: ["beta"]
    }
    options = Map.merge(options, %{as_major: true})

    assert Semver.beta(version, options) == expected
  end

  test "beta/1 stops and logs an error when used with incompatible current pre-release", %{
    version: version,
    options: options
  } do
    version = %{version | pre: ["rc"]}

    fun = fn ->
      assert catch_exit(Semver.beta(version, options)) == :shutdown
    end

    assert capture_log(fun) =~ "Can not create beta"
    assert capture_log(fun) =~ "#{version}"
  end

  ### rc

  test "rc/1 increases patch version and adds rc pre-release", %{
    version: version,
    options: options
  } do
    expected = %Version{
      major: version.major,
      minor: version.minor,
      patch: version.patch + 1,
      pre: ["rc"]
    }

    assert Semver.rc(version, options) == expected
  end

  test "rc/1 increases minor version and appends rc pre-release", %{
    version: version,
    options: options
  } do
    expected = %Version{
      major: version.major,
      minor: version.minor + 1,
      patch: 0,
      pre: ["rc"]
    }
    options = Map.merge(options, %{as_minor: true})

    assert Semver.rc(version, options) == expected
  end

  test "rc/1 increases major version and adds rc pre-release", %{
    version: version,
    options: options
  } do
    expected = %Version{
      major: version.major + 1,
      minor: 0,
      patch: 0,
      pre: ["rc"]
    }
    options = Map.merge(options, %{as_major: true})

    assert Semver.rc(version, options) == expected
  end

  ## release

  test "stable/1 removes the pre-release from given version" do
    version = %Version{
      major: 1,
      minor: 0,
      patch: 0,
      pre: ["alpha"]
    }

    expected = %Version{
      major: 1,
      minor: 0,
      patch: 0
    }

    assert Semver.stable(version) == expected
  end

  test "stable/1 exits and logs an error when used with a not pre-released version" do
    version = %Version{
      major: 1,
      minor: 0,
      patch: 0
    }

    fun = fn ->
      assert catch_exit(Semver.stable(version)) == :shutdown
    end

    assert capture_log(fun) =~ "Can not create stable release from already stable version"
  end
end
