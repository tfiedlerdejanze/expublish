defmodule Expublish.Publish do
  @moduledoc """
  Shell commands for hex publish.
  """

  require Logger

  @doc """
  Run mix hex.publish --yes.
  """
  def run do
    error_code = Mix.Shell.IO.cmd("mix hex.publish --yes", [])

    if error_code != 0 do
      Logger.error("Failed while publishing package to hex.")
      exit(:shutdown)
    end

    :ok
  end
end

