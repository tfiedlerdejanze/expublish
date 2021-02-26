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
    @moduledoc "Release and publish next major version of current project."
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
    @moduledoc "Release and publish next minor version of current project."
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
    @moduledoc "Release and publish next patch version of current project."
    @shortdoc "Publish a patch version of current project."
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.patch()
    end
  end

  defmodule Alpha do
    @moduledoc """
    Release and publish alpha pre-release for next major version of current project.

    Next version level controlled via mix task arguments defined as `Expublish.Options`.
    """
    @shortdoc "Publish alpha pre-release for next major version of current project."
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.alpha()
    end
  end

  defmodule Beta do
    @moduledoc """
    Release and publish beta pre-release for next major version of current project.

    Next version level controlled via mix task arguments defined as `Expublish.Options`.
    """
    @shortdoc "Publish beta pre-release for next major version of current project."
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.beta()
    end
  end

  defmodule Rc do
    @moduledoc """
    Release and publish alpha pre-release for next major version of current project.

    Next version level controlled via mix task arguments defined as `Expublish.Options`.
    """
    @shortdoc "Publish release-candidate pre-release for next major version of current project."
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.rc()
    end
  end

  defmodule Release do
    @moduledoc """
    Removes pre-release suffix from version and publishes current project.
    """
    @shortdoc "Removes pre-release suffix from version and publishes current project."
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.release()
    end
  end
end
