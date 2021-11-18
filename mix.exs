defmodule LolWatcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :lol_watcher,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {LolWatcher.Application, []}
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:gen_stage, "~> 1.1"},
      {:flow, "~> 1.1"},
      {:tesla_cache, "~> 1.1"},
      {:jason, "~> 1.2"}
    ]
  end
end
