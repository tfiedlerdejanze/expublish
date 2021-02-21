defmodule Expublish.Publish do
  @moduledoc """
  Shell commands for hex publish.
  """

  require Logger

  alias Expublish.Options

  @doc """
  Run mix hex.publish --yes.
  """
  def run(options \\ []) do
    error_code =
      if Options.skip_publish?(options),
        do: 0,
        else: Mix.Shell.IO.cmd("mix hex.publish --yes", [])

    if error_code != 0 do
      Logger.error("Failed while publishing package to hex.")
      exit(:shutdown)
    end

    :ok
  end
end
