defmodule Expublish.Tests do
  @moduledoc """
  Shell commands for triggering mix test.
  """

  alias Expublish.Options

  require Logger

  @doc """
  Run tests, stop task if they fail, skip if there are none.
  """
  @type level() :: :major | :minor | :patch | :rc | :beta | :alpha | :stable
  @spec run(level(), Options.t()) :: level
  def run(level, options)

  def run(level, %{disable_test: true}) do
    Logger.warn("Skipping test run for #{to_string(level)} release.")
    level
  end

  def run(level, _options) do
    if Mix.env() != :test do
      Logger.info("Starting test run for #{to_string(level)} release.")
      error_code = Mix.Shell.IO.cmd("mix test")

      if error_code != 0 do
        Logger.error("Test run failed. Abort.")
        exit(:shutdown)
      end
    end

    level
  end
end
