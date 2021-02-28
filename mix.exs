defmodule Expublish.MixProject do
  use Mix.Project

  @description "Automates semantic release versioning and best practices for elixir packages."
  @source_url "https://github.com/ucwaldo/expublish"
  @hexdocs_url "https://hexdocs.pm/expublish"

  def project do
    [
      app: :expublish,
      version: "2.5.0",
      package: package(),
      description: @description,
      source_url: @source_url,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: [
          "README.md",
          "CHANGELOG.md": [filename: "changelog", title: "Changelog"],
          "docs/INSTALLATION.md": [filename: "installation", title: "Installation"],
          "docs/CHEATSHEET.md": [filename: "cheatsheet", title: "Cheatsheet"],
          "docs/VERSION_LEVELS.md": [filename: "version_levels", title: "Version levels"],
          "docs/REFERENCE.md": [filename: "reference", title: "Reference"]
        ]
      ],
      dialyzer: [
        plt_core_path: "priv/plts",
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => @hexdocs_url <> "/changelog.html",
        "Installation" => @hexdocs_url <> "/installation.html",
        "Reference" => @hexdocs_url <> "/reference.html"
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
      {:ex_doc, "~> 0.14", only: :dev, runtime: false, optional: true},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false, optional: true},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false, optional: true}
    ]
  end
end
