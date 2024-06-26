defmodule Expublish.TestSystem do
  @moduledoc false

  require Logger

  def cmd(command, args, _options \\ []) do
    args_string = Enum.join(args, " ")

    "#{command} #{args_string}"
    |> String.trim()
    |> Logger.info()

    {"", 0}
  end
end
