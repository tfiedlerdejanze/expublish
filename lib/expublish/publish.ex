defmodule Expublish.Publish do
  @moduledoc """
  Shell commands for hex publish.
  """

  require Logger

  alias Expublish.Options

  @doc """
  Run mix hex.publish --yes.
  """
  def run(%Version{} = version, options \\ []) do
    if !Options.dry_run?(options) && !Options.skip_publish?(options) do
      error_code = Mix.Shell.IO.cmd("mix hex.publish --yes", [])

      if error_code != 0 do
        Logger.error("Failed to publish new package on hex.")
      end
    end

    if Options.dry_run?(options) || Options.skip_publish?(options) do
      Logger.info("Skipping mix hex.publish.")
    end

    if Options.dry_run?(options) do
      Logger.info("Finished dry run for new package version: #{version}.")
    else
      Logger.info("Successfully created new package version: #{version}.")
    end

    version
  end
end
