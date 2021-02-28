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
  @spec validate(level(), Options.t()) :: :ok
  def validate(level, options)

  def validate(level, %{disable_test: true}) do
    Logger.warn("Skipping test validate for #{to_string(level)} release.")
    :ok
  end

  def validate(level, _options) do
    if Mix.env() != :test do
      Logger.info("Starting test run for #{to_string(level)} release.")
      error_code = Mix.Shell.IO.cmd("mix test")

      if error_code != 0,
        do: "Test run failed. Abort.",
        else: :ok
    else
      :ok
    end
  end
end
