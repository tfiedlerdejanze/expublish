defmodule Expublish.Tests do
  @moduledoc """
  Shell commands for triggering mix test.
  """

  require Logger

  @doc """
  Run tests, stop task if they fail, skip if there are none.
  """
  def run do
    error_code = Mix.Shell.IO.cmd("mix test", [])

    if error_code != 0 do
      Logger.error("This version can't be released because tests are failing.")
      exit(:shutdown)
    end

    :ok
  end
end
