defmodule Expublish.Publish do
  @moduledoc """
  Shell commands for hex publish.
  """

  @doc """
  Invokes mix hex.publish or raises on error.
  """
  def run! do
    error_code = Mix.Shell.IO.cmd("mix hex.publish --yes", [])

    if error_code != 0 do
      raise "Failed to publish package."
    end

    :ok
  end
end

