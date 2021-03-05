defmodule ProjectTest do
  use ExUnit.Case
  doctest Expublish

  @version Version.parse!("1.0.0")
  @version_file_path "test/files/VERSION.txt"

  import ExUnit.CaptureLog
  import Expublish.TestHelper
  alias Expublish.Options
  alias Expublish.Project

  setup do
    [options: Options.parse(["--dry-run"]), version: @version]
  end

  defp get_test_file_version do
    File.read!(@version_file_path)
    |> String.trim()
    |> Version.parse!()
  end

  test "get_version!/0 reads current project version from mix" do
    expected = Mix.Project.config()[:version] |> Version.parse!()

    assert Project.get_version!() == expected
  end

  test "update_version!/2 does nothing in dry run", %{options: options, version: version} do
    fun = fn ->
      Project.update_version!(version, options)
    end

    assert capture_log(fun) =~ "Skipping new version in mix.exs"
  end

  test "update_version!/2 updates current project version in --version-file" do
    version = get_test_file_version()
    new_version = %{version | patch: version.patch + 1}

    fun = fn ->
      Project.update_version!(new_version, %Options{version_file: @version_file_path})
    end

    assert capture_log(fun) =~ "Writing new version to #{@version_file_path}"
    assert new_version == get_test_file_version()

    File.write(@version_file_path, "#{version}")
  end

  test "update_version!/2 updates current project version in mix.exs" do
    mix_exs = File.read!("mix.exs")
    version = Project.get_version!()
    new_version = %{version | patch: version.patch + 1}

    fun = fn ->
      with_release_md(fn ->
        assert new_version == Project.update_version!(new_version, %Options{})
      end)
    end

    assert capture_log(fun) =~ "Writing new version to mix.exs."

    File.write!("mix.exs", mix_exs)
  end

  test "update_version!/2 exits task if it fails to write the new version", %{version: version} do
    mix_exs = File.read!("mix.exs")
    new_version = Version.parse!("1.0.0")

    fun = fn ->
      assert catch_exit(Project.update_version!(new_version, %Options{}, version)) == :shutdown
    end

    assert capture_log(fun) =~ "Could not update version in mix.exs."

    File.write!("mix.exs", mix_exs)
  end
end
