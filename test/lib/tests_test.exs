defmodule TestsTest do
  use ExUnit.Case
  doctest Expublish

  import ExUnit.CaptureLog
  alias Expublish.Options
  alias Expublish.Tests

  setup do
    [options: Options.parse(["--dry-run", "--disable-test"])]
  end

  test "validate/0 validates without errors", %{options: options} do
    fun = fn -> Tests.validate(options, :major) end

    assert capture_log(fun) =~ "Skipping test run"
    assert capture_log(fun) =~ "major release"
  end
end
