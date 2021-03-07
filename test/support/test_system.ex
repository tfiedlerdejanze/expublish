defmodule TestSystem do
  @moduledoc false

  require Logger

  def cmd(command, options \\ []) do
    options_string = Enum.join(options, " ")

    "#{command} #{options_string}"
    |> String.trim()
    |> Logger.info()

    {"", 0}
  end
end
