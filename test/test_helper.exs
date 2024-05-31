ExUnit.start()

Application.put_env(:expublish, :system_adapter, Expublish.TestSystem)
Application.put_env(:expublish, :shell_adapter, Expublish.TestShell)
