defmodule PublishTest do
  use ExUnit.Case
  doctest Expublish

  import ExUnit.CaptureLog
  alias Expublish.Hex
  alias Expublish.Options

  @version %Version{major: 1, minor: 0, patch: 1}

  setup do
    [options: Options.parse(["--dry-run"]), version: @version]
  end

  test "run/2 runs without errors", %{options: options, version: version} do
    fun = fn ->
      Hex.publish(version, options)
    end

    assert capture_log(fun) =~ "Skipping \"mix hex.publish --yes\""
  end
end
