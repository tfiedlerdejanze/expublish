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
          "INSTALLATION.md": [filename: "installation", title: "Installation"],
          "CHANGELOG.md": [filename: "changelog", title: "Changelog"],
          "CHEATSHEET.md": [filename: "cheatsheet", title: "Cheatsheet"],
          "VERSION_LEVELS.md": [filename: "version_levels", title: "Version levels"],
          "REFERENCE.md": [filename: "reference", title: "Reference"],
        ]
      ],
      dialyzer: [
        plt_core_path: "priv/plts",
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  defp description(), do: "Automates semantic release versioning and best practices for elixir packages."

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/ucwaldo/expublish",
        "Changelog" => "https://github.com/ucwaldo/expublish/blob/master/CHANGELOG.md",
        "Installation" => "https://github.com/ucwaldo/expublish/blob/master/INSTALLATION.md",
        "Reference" => "https://github.com/ucwaldo/expublish/blob/master/REFERENCE.md"
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
