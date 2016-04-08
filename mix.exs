defmodule Purduedir.Mixfile do
  use Mix.Project

  def project do
    [app: :purduedir,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Purduedir],  # <- add this line
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [ mod: { Purduedir, [] },
      applications: [:logger, :httpoison, :cowboy, :plug, :redix, :table_rex, :httpoison, :json, :plug, :redix, :table_rex, :exquery]]
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

    [{:httpoison, "~> 0.8.0"},
    {:exquery, "~> 0.0.11"},
    { :json,   "~> 0.3.0"},
    {:cowboy, "~> 1.0"},
    {:plug, "~> 1.0"},
    {:redix, ">= 0.0.0"},
    {:exrm, "~> 0.18.1"},
    {:table_rex, "~> 0.8.0"}]
  end
end
