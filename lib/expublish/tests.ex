defmodule Expublish.Tests do
  @moduledoc """
  Shell commands for triggering mix test.
  """

  @doc """
  Run tests, raise if they fail, skip if there are none.
  """
  def run! do
    error_code = Mix.Shell.IO.cmd("mix test", [])

    if error_code != 0 do
      raise "This version can't be released because tests are failing."
    end

    :ok
  end
end
