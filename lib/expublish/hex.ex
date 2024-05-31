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
  def publish(version, options \\ %Options{})

  def publish(version, %Options{dry_run: false, disable_publish: false}) do
    Logger.info("Publishing new package version with: \"mix hex.publish --yes\".\n")

    case Expublish.System.cmd("mix", ["hex.publish", "--yes"]) do
      {_, 0} ->
        Logger.info("Successfully published new package version on hex.")

      _error ->
        Logger.error("Failed to publish new package version on hex.")
    end

    version
  end

  def publish(version, _options) do
    Logger.info("Skipping \"mix hex.publish --yes\".")

    version
  end
end
