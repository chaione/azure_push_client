defmodule AzurePushClient.Mixfile do
  use Mix.Project

  def project do
    [app: :azure_push_client,
     version: "0.0.7",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison],
     mod: {AzurePushClient, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.9.0"},
     {:poison, "~> 2.0"},
     {:ex_doc, ">= 0.0.0", only: :dev},
     {:credo, "~> 0.4.5", only: [:dev, :test]}]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE*"],
      maintainers: ["Robert Boone"],
      description: "Azure Push Client",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/chaione/azure_push_client"}
    ]
  end
end
