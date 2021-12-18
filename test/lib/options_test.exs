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

    opts = %{dry_run: true, allow_untracked: true, branch: "release"}
    expected = Options.defaults() |> Map.merge(opts)

    assert expected == Options.parse(arguments)
  end

  test "parse/1 exits and and prints help with --help" do
    arguments = ["--help"]

    fun = fn ->
      assert catch_exit(Options.parse(arguments)) == :shutdown
    end

    assert capture_io(fun) =~ "Usage: mix expublish"
  end

  test "parse/1 exits and logs an error when options are invalid" do
    arguments = ["--dry-run=yes"]

    fun = fn ->
      assert catch_exit(Options.parse(arguments)) == {:shutdown, 1}
    end

    assert capture_log(fun) =~ "error"
    assert capture_log(fun) =~ "Invalid option"
    assert capture_log(fun) =~ "--dry-run"
  end

  test "validate/2 returns ok for valid level and default options" do
    assert Options.validate(%Options{}, :major) == :ok
    assert Options.validate(%Options{}, :minor) == :ok
    assert Options.validate(%Options{}, :patch) == :ok
    assert Options.validate(%Options{}, :alpha) == :ok
    assert Options.validate(%Options{}, :beta) == :ok
    assert Options.validate(%Options{}, :rc) == :ok
  end

  test "validate/2 returns ok for valid level and options" do
    assert Options.validate(%Options{as_major: true}, :alpha) == :ok
    assert Options.validate(%Options{as_minor: true}, :alpha) == :ok
    assert Options.validate(%Options{as_major: true}, :beta) == :ok
    assert Options.validate(%Options{as_minor: true}, :beta) == :ok
    assert Options.validate(%Options{as_major: true}, :rc) == :ok
    assert Options.validate(%Options{as_minor: true}, :rc) == :ok
  end

  test "validate/2 returns error string for invalid valid level and options" do
    assert Options.validate(%Options{as_major: true}, :major) =~ "Invalid task"
    assert Options.validate(%Options{as_minor: true}, :major) =~ "Invalid task"
    assert Options.validate(%Options{as_major: true}, :minor) =~ "Invalid task"
    assert Options.validate(%Options{as_minor: true}, :minor) =~ "Invalid task"
    assert Options.validate(%Options{as_major: true}, :patch) =~ "Invalid task"
    assert Options.validate(%Options{as_minor: true}, :patch) =~ "Invalid task"
  end

  test "print_help/0 prints help via io" do
    fun = fn -> Options.print_help() end

    assert capture_io(fun) =~ "Usage: mix expublish"
  end
end
