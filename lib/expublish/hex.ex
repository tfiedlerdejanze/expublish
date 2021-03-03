defmodule Expublish.Hex do
  @moduledoc """
  Shell commands for hex publish.
  """

  alias Expublish.Options

  require Logger

  @doc """
  Run mix hex.publish --yes.
  """
  @spec publish(Version.t(), Options.t(), module()) :: Version.t()
  def publish(version, options \\ %Options{}, syscall_module \\ System)

  def publish(version, %Options{dry_run: false, disable_publish: false}, syscall_module) do
    Logger.info("Publishing new package version with: \"mix hex.publish --yes\".\n")
    {_, error_code} = syscall_module.cmd("mix", ["hex.publish", "--yes"])

    if error_code == 0,
      do: Logger.info("Successfully published new package version on hex."),
      else: Logger.error("Failed to publish new package version on hex.")

    version
  end

  def publish(version, _options, _syscall_module) do
    Logger.info("Skipping \"mix hex.publish --yes\".")

    version
  end
end
