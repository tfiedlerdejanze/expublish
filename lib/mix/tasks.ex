defmodule Mix.Tasks.Publish do
  @moduledoc false

  defmodule Major do
    @moduledoc "Release and publish major version for current project."
    @shortdoc "Publish a major version of your library."
    use Mix.Task

    @doc false
    def run(_), do: Expublish.major()
  end

  defmodule Minor do
    @moduledoc "Release and publish minor version for current project."
    @shortdoc "Publish a minor version of your library."
    use Mix.Task

    @doc false
    def run(_), do: Expublish.minor()
  end

  defmodule Patch do
    @moduledoc "Release and publish patch version for current project."
    @shortdoc "Publish a patch version of your library."
    use Mix.Task

    @doc false
    def run(_), do: Expublish.patch()
  end
end
