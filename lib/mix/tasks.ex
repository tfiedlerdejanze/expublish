defmodule Mix.Tasks.Expublish do
  @moduledoc """
  Mix tasks for releasing and publishing new project versions.
  """

  alias Expublish.Options

  @shortdoc "Print help for expublish."
  use Mix.Task

  @doc false
  def run(_args) do
    Options.print_help()
  end

  defmodule Major do
    @moduledoc "Release and publish major version for current project."
    @shortdoc "Publish a major version of current project."
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.major()
    end
  end

  defmodule Minor do
    @moduledoc "Release and publish minor version for current project."
    @shortdoc "Publish a minor version of current project."
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.minor()
    end
  end

  defmodule Patch do
    @moduledoc "Release and publish patch version for current project."
    @shortdoc "Publish a patch version of current project."
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.patch()
    end
  end
end
