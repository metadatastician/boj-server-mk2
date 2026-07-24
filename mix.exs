defmodule BojServerMk2.MixProject do
  use Mix.Project

  def project do
    [
      app: :boj_server_mk2,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:burrito, "~> 1.0"},
      {:benchee, "~> 1.0", only: :dev},
      {:wasmex, "~> 0.8.3"}
    ]
  end
end
