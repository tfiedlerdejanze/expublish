defmodule Expublish.MixProject do
  use Mix.Project

  def project do
    [
      app: :expublish,
      version: "1.0.0",
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

  defp description(), do: "Automated version and changelog management for elixir packages."

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/ucwaldo/expublish"}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end
end
