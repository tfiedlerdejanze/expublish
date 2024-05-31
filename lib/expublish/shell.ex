defmodule Expublish.Shell do
  @moduledoc false

  def cmd(command, opts \\ []) do
    adapter().cmd(command, opts)
  end

  defp adapter do
    Application.get_env(:expublish, :shell_adapter, Mix.Shell.IO)
  end
end
