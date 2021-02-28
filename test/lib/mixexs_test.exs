defmodule MixexsTest do
  use ExUnit.Case
  doctest Expublish

  alias Expublish.Mixexs
  alias Expublish.Options

  setup do
    [options: Options.parse(["--dry-run"])]
  end

  test "get_version!/0 reads current project version from mix" do
    expected = Mix.Project.config()[:version] |> Version.parse!()

    assert Mixexs.get_version!() == expected
  end
end
