defmodule Expublish.MixProject do
  use Mix.Project

  def project do
    [
      app: :expublish,
      version: "2.3.2",
      package: package(),
      description: description(),
      source_url: "https://github.com/ucwaldo/expublish",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  defp description(), do: "Automate SemVer and best practices for elixir package releases."

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/ucwaldo/expublish",
        "Changelog" => "https://github.com/ucwaldo/expublish/blob/master/CHANGELOG.md"
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end
end
