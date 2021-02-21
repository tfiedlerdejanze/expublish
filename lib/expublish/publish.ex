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
      Expublish.message_and_stop("Failed while publishing package to hex.")
    end

    :ok
  end
end

