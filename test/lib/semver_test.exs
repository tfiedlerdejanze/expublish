defmodule SemverTest do
  use ExUnit.Case
  doctest Expublish

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

  test "bump_major/1 increases major level of version", %{version: version} do
    expected = %Version{major: version.major + 1, minor: 0, patch: 0}

    assert Semver.bump_major(version) == expected
  end

  test "bump_minor/1 increases minor level of version", %{version: version} do
    expected = %Version{major: version.major, minor: version.minor + 1, patch: 0}

    assert Semver.bump_minor(version) == expected
  end

  test "bump_patch/1 increases patch level of version", %{version: version} do
    expected = %Version{major: version.major, minor: version.minor, patch: version.patch + 1}

    assert Semver.bump_patch(version) == expected
  end
end
