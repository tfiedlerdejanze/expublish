defmodule Expublish.Hex do
  @moduledoc """
  Shell commands for hex publish.
  """

  require Logger

  @doc """
  Run mix hex.publish --yes.
  """
  def publish(version, %{dry_run: false, disable_publish: false}) do
    error_code = Mix.Shell.IO.cmd("mix hex.publish --yes", [])

    if error_code == 0,
      do: Logger.info("Successfully created new package version: #{version}."),
      else: Logger.error("Failed to publish new package on hex.")

    version
  end

  def publish(version, %{dry_run: true}) do
    Logger.info("Skipping mix hex.publish.")
    Logger.info("Finished dry run for new package version: #{version}.")
    version
  end

  def publish(version, _options) do
    Logger.info("Skipping mix hex.publish.")
    version
  end
end
