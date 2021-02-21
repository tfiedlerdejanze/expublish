defmodule Mix.Tasks.Expublish do
  @moduledoc """
  Release and publish new version for current project.

  You will be prompted for the version level, must be one of `major`, `minor` or `patch`.
  """

  alias Expublish.Options

  @shortdoc "Publish a new version of current project."
  use Mix.Task

  @doc false
  def run(args) do
    args
    |> Options.parse()
    |> prompt_for_version_and_publish()
  end

  defp prompt_for_version_and_publish(options) do
    "Enter version level: major | minor | patch\n"
    |> IO.gets()
    |> String.trim()
    |> String.downcase()
    |> case do
      "major" -> Expublish.major(options)
      "minor" -> Expublish.minor(options)
      "patch" -> Expublish.patch(options)
      _ -> prompt_for_version_and_publish(options)
    end
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
