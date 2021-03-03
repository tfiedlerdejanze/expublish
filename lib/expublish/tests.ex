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
  @spec validate(Options.t(), level()) :: :ok
  def validate(options, level)

  def validate(%Options{disable_test: true}, level) do
    Logger.warn("Skipping test run for #{to_string(level)} release.")
    :ok
  end

  def validate(_options, level) do
    Logger.info("Starting test run for #{to_string(level)} release.")
    syscall_module = if Mix.env == :test, do: TestSystemCall, else: Mix.Shell.IO
    error_code = case syscall_module.cmd("mix test") do
      {_, return_code} -> return_code
      return_code -> return_code
    end

    if error_code != 0,
      do: "Test run failed. Abort.",
      else: :ok
  end
end
