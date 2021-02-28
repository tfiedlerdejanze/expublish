defmodule VersionFileTest do
  use ExUnit.Case
  doctest Expublish

  alias Expublish.VersionFile
  alias Expublish.Options

  setup do
    [options: Options.parse(["--dry-run"])]
  end

  test "read/0 reads current project version from mix" do
    expected = Mix.Project.config()[:version] |> Version.parse!()

    assert VersionFile.get_version!() == expected
  end
end
