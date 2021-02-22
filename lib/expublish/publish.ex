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
    if !Options.dry_run?(options) && !Options.skip_publish?(options) do
      error_code = Mix.Shell.IO.cmd("mix hex.publish --yes", [])

      if error_code != 0 do
        Logger.error("Failed while publishing package to hex.")
        exit(:shutdown)
      end
    end

    :ok
  end
end
