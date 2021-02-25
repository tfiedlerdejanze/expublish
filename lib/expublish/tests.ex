defmodule Expublish.Tests do
  @moduledoc """
  Shell commands for triggering mix test.
  """

  alias Expublish.Options

  require Logger

  @doc """
  Run tests, stop task if they fail, skip if there are none.
  """
  @spec run(Options.t()) :: :ok | :exit
  def run(options)

  def run(%{disable_test: true}) do
    Logger.warn("Skipping test run.")
    :ok
  end

  def run(_options) do
    if Mix.env() != :test do
      error_code = Mix.Shell.IO.cmd("mix test")

      if error_code != 0 do
        Logger.error("Test run failed. Abort.")
        exit(:shutdown)
      end
    end

    :ok
  end
end
