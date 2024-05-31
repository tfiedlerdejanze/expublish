defmodule Expublish.TestShell do
  @moduledoc false

  require Logger

  def cmd(command, args \\ []) do
    args_string = Enum.join(args, " ")

    "#{command} #{args_string}"
    |> String.trim()
    |> Logger.info()

    0
  end
end
