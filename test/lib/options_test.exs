defmodule OptionsTest do
  use ExUnit.Case
  doctest Expublish

  import ExUnit.CaptureLog
  alias Expublish.Options

  test "parse/1 parses multiple valid options" do
    arguments = ["--dry-run", "--allow-untracked", "--branch=release"]
    expected = Options.defaults() |> Map.merge(%{dry_run: true, allow_untracked: true, branch: "release"})

    assert expected == Options.parse(arguments)
  end

  test "parse/1 logs a warning when options are invalid" do
    arguments = ["--dry-run=yes"]
    fun = fn ->
      assert catch_exit(Options.parse(arguments)) == :shutdown
    end

    assert capture_log(fun) =~ "Invalid mix task options"
  end
end
