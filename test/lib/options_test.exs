defmodule OptionsTest do
  use ExUnit.Case
  doctest Expublish

  alias Expublish.Options

  test "parse/1 parses multiple valid options" do
    arguments = ["--dry-run", "--allow-untracked", "--branch=release"]
    expected = Options.defaults() |> Map.merge(%{dry_run: true, allow_untracked: true, branch: "release"})

    assert expected == Options.parse(arguments)
  end

  test "parse/1 stops the task execution when options are invalid" do
    arguments = ["--dry-run=yes"]

    assert catch_exit(Options.parse(arguments)) == :shutdown
  end
end
