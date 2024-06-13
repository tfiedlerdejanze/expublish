defmodule Mix.Tasks.Expublish do
  @shortdoc "Print help for expublish."
  @moduledoc """
  Mix tasks for releasing and publishing new project versions.

  OptionParser interface defined in `Expublish.Options.`
  """

  use Mix.Task

  alias Expublish.Options

  @doc false
  def run(_args) do
    Options.print_help()
  end

  defmodule Release do
    @shortdoc "Publish a new version of current project."
    @moduledoc """
    Release and publish new version of current project.

    The changelog entry and next version will be inferred
    from commits following the commitizen specification.

    OptionParser interface defined in `Expublish.Options.`
    """
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.release()
    end
  end

  defmodule Major do
    @shortdoc "Publish a major version of current project."
    @moduledoc """
    Release and publish next major version of current project.

    OptionParser interface defined in `Expublish.Options.`
    """
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.major()
    end
  end

  defmodule Minor do
    @shortdoc "Publish a minor version of current project."
    @moduledoc """
    Release and publish next minor version of current project.

    OptionParser interface defined in `Expublish.Options.`
    """
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.minor()
    end
  end

  defmodule Patch do
    @shortdoc "Publish a patch version of current project."
    @moduledoc """
    Release and publish next patch version of current project.

    OptionParser interface defined in `Expublish.Options.`
    """
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.patch()
    end
  end

  defmodule Alpha do
    @shortdoc "Publish alpha pre-release for next major version of current project."
    @moduledoc """
    Release and publish alpha pre-release for next major version of current project.

    Next version level controlled via mix task arguments defined as `Expublish.Options`.
    """
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.alpha()
    end
  end

  defmodule Beta do
    @shortdoc "Publish beta pre-release for next major version of current project."
    @moduledoc """
    Release and publish beta pre-release for next major version of current project.

    Next version level controlled via mix task arguments defined as `Expublish.Options`.
    """
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.beta()
    end
  end

  defmodule Rc do
    @shortdoc "Publish release-candidate pre-release for next major version of current project."
    @moduledoc """
    Release and publish alpha pre-release for next major version of current project.

    Next version level controlled via mix task arguments defined as `Expublish.Options`.
    """
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.rc()
    end
  end

  defmodule Stable do
    @shortdoc "Removes pre-release from version and publishes current project."
    @moduledoc """
    Removes pre-release from version and publishes current project.

    OptionParser interface defined in `Expublish.Options.`
    """
    use Mix.Task

    @doc false
    def run(args) do
      args
      |> Options.parse()
      |> Expublish.stable()
    end
  end
end
