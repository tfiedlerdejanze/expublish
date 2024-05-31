defmodule Expublish.System do
  @moduledoc false
  def cmd(command, args, opts \\ []) do
    adapter().cmd(command, args, opts)
  end

  defp adapter do
    Application.get_env(:expublish, :system_adapter, System)
  end
end
