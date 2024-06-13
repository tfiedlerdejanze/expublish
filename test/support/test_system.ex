defmodule Expublish.TestSystem do
  @moduledoc false

  require Logger

  def cmd(command, args, options \\ [])

  def cmd("git" = command, ["describe", "--tags" | _] = args, _options) do
    args_string = Enum.join(args, " ")

    "#{command} #{args_string}"
    |> String.trim()
    |> Logger.info()

    {"1.0.0", 0}
  end

  def cmd("git" = command, ["log" | _] = args, _options) do
    args_string = Enum.join(args, " ")

    "#{command} #{args_string}"
    |> String.trim()
    |> Logger.info()

    {"123 feat: some commit\n456 fix: another commit", 0}
  end

  def cmd(command, args, _options) do
    args_string = Enum.join(args, " ")

    "#{command} #{args_string}"
    |> String.trim()
    |> Logger.info()

    {"", 0}
  end
end
