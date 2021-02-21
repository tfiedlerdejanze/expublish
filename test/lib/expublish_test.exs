defmodule ExpublishTest do
  use ExUnit.Case
  doctest Expublish

  alias Expublish.Options
  alias Expublish.Semver

  setup do
    [options: Options.parse(["--dry-run"])]
  end

  test "Semver.update_version!/2 increases the version", %{options: options} do
    version = Semver.get_version()
    new_version = Semver.update_version!("patch", options)

    assert :gt == Version.compare(new_version, version)
  end
end
