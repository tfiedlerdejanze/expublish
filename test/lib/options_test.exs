defmodule OptionsTest do
  use ExUnit.Case
  doctest Expublish

  alias Expublish.Options

  test "parse/1 parses many options at once" do
    options = Options.parse(["--dry-run", "--allow-untracked"])
    expected = Options.defaults() |> Map.merge(%{dry_run: true, allow_untracked: true})

    assert expected == options
  end

  test "parse/1 ignores invalid options" do
    options = Options.parse(["--dry-run=yes"])
    expected = Options.defaults()

    assert expected == options
  end
end
