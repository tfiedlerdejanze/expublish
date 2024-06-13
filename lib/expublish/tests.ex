defmodule Expublish.Tests do
  @moduledoc """
  Shell commands for triggering mix test.
  """

  alias Expublish.Options

  require Logger

  @doc """
  Run tests, stop task if they fail, skip if there are none.
  """
  @type level() :: :release | :major | :minor | :patch | :rc | :beta | :alpha | :stable
  @spec validate(Options.t(), level()) :: :ok | String.t()
  def validate(%Options{disable_test: true}, level) do
    Logger.info("Skipping test run for #{to_string(level)} release.")

    :ok
  end

  def validate(_options, level) do
    Logger.info("Starting test run for #{to_string(level)} release.")

    case Expublish.Shell.cmd("mix test") do
      0 -> :ok
      _ -> "Test run failed. Abort."
    end
  end
end
