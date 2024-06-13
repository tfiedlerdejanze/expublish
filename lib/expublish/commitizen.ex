defmodule Expublish.Commitizen do
  @moduledoc """
  Implements commitizen specification.

  https://www.conventionalcommits.org/en/v1.0.0/#specification
  """

  defstruct all: [], patch: [], feature: [], breaking: []

  def run(commits) do
    collect(commits)
  end

  defp collect(commits, acc \\ %__MODULE__{})

  defp collect([], acc), do: acc

  defp collect(["fix" <> _ = commit | rest], acc) do
    collect(rest, %__MODULE__{acc | all: [commit | acc.all], patch: [commit | acc.patch]})
  end

  defp collect(["feat" <> _ = commit | rest], acc) do
    collect(rest, %__MODULE__{acc | all: [commit | acc.all], feature: [commit | acc.feature]})
  end

  defp collect(["BREAKING CHANGE" <> _ = commit | rest], acc) do
    collect(rest, %__MODULE__{acc | all: [commit | acc.all], breaking: [commit | acc.breaking]})
  end

  defp collect([_ | rest], acc) do
    collect(rest, acc)
  end
end
