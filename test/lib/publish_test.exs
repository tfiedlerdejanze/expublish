defmodule PublishTest do
  use ExUnit.Case
  doctest Expublish

  import ExUnit.CaptureLog
  alias Expublish.Options
  alias Expublish.Publish

  @version %Version{major: 1, minor: 0, patch: 1}

  setup do
    [options: Options.parse(["--dry-run"]), version: @version]
  end

  test "run/2 runs without errors", %{options: options, version: version} do
    fun = fn ->
      Publish.run(version, options)
    end

    assert capture_log(fun) =~ "new package version: #{version}"
  end
end
