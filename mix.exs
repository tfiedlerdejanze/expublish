defmodule Expublish.MixProject do
  use Mix.Project

  def project do
    [
      app: :expublish,
      version: "2.3.4",
      package: package(),
      description: description(),
      source_url: "https://github.com/ucwaldo/expublish",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: [
          "README.md",
          "ABOUT.md": [filename: "about", title: "About"],
          "INSTALLATION.md": [filename: "installation", title: "Installation"],
          "GETTING_STARTED.md": [filename: "getting_started", title: "Getting started"],
          "EXAMPLES.md": [filename: "examples", title: "Examples"],
          "REFERENCE.md": [filename: "reference", title: "Reference"],
          "CHANGELOG.md": [filename: "changelog", title: "Changelog"],
        ]
      ],
      dialyzer: [
        plt_core_path: "priv/plts",
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  defp description(), do: "Automates SemVer and best practices for elixir package releases."

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/ucwaldo/expublish",
        "Changelog" => "https://github.com/ucwaldo/expublish/blob/master/CHANGELOG.md",
        "Installation" => "https://github.com/ucwaldo/expublish/blob/master/INSTALLATION.md"
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger, :mix]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end
end
