defmodule OptionsTest do
  use ExUnit.Case
  doctest Expublish

  import ExUnit.CaptureLog
  import ExUnit.CaptureIO
  alias Expublish.Options

  test "defaults/0 returns default options" do
    assert Options.defaults() == %Options{branch: "master"}
    assert Options.defaults() == %Options{remote: "origin"}

    refute Options.defaults() == %Options{allow_untracked: true}
    refute Options.defaults() == %Options{dry_run: true}
  end

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

    assert capture_log(fun) =~ "Invalid option"
    assert capture_log(fun) =~ "--dry-run"
  end

  test "print_help/0 prints help via io" do
    fun = fn -> Options.print_help() end

    assert capture_io(fun) =~ "Usage: mix expublish"
  end
end
