defmodule TestsTest do
  use ExUnit.Case
  doctest Expublish

  import ExUnit.CaptureLog
  alias Expublish.Options
  alias Expublish.Tests

  setup do
    [options: Options.parse(["--dry-run", "--disable-test"])]
  end

  test "run/0 runs without errors", %{options: options} do
    fun = fn -> Tests.run(options) end

    assert capture_log(fun) =~ "Skipping test run"
  end
end
