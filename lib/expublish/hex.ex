defmodule Expublish.Hex do
  @moduledoc """
  Shell commands for hex publish.
  """

  alias Expublish.Options

  require Logger

  @doc """
  Run mix hex.publish --yes.
  """
  @spec publish(Version.t(), Options.t()) :: Version.t()
  def publish(version, %Options{dry_run: false, disable_publish: false}) do
    Logger.info("Publishing new package version with: \"mix hex.publish --yes\".\n")
    {_, error_code} = System.cmd("mix", ["hex.publish", "--yes"])

    if error_code == 0,
      do: Logger.info("Successfully published new package version on hex."),
      else: Logger.error("Failed to publish new package version on hex.")

    version
  end

  def publish(version, _options) do
    Logger.info("Skipping \"mix hex.publish --yes\".")

    version
  end
end
