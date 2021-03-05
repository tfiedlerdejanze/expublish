defmodule PublishTest do
  use ExUnit.Case
  doctest Expublish

  import ExUnit.CaptureLog
  alias Expublish.Hex
  alias Expublish.Options

  @version Version.parse!("1.0.1")

  setup do
    [options: Options.parse(["--dry-run"]), version: @version]
  end

  test "publish/2 runs without errors", %{options: options, version: version} do
    fun = fn -> Hex.publish(version, options) end

    assert capture_log(fun) =~ "Skipping \"mix hex.publish --yes\""
  end

  test "publish/2 does expected system call", %{version: version} do
    options = %Options{}

    fun = fn ->
      Hex.publish(version, options, TestSystemCall)
    end

    assert capture_log(fun) =~ "mix hex.publish --yes"
  end
end
