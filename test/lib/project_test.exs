defmodule ProjectTest do
  use ExUnit.Case
  doctest Expublish

  @version_file_path "test/files/VERSION.txt"

  import ExUnit.CaptureLog
  alias Expublish.Options
  alias Expublish.Project

  setup do
    [options: Options.parse(["--dry-run"])]
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
end
