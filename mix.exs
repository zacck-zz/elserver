defmodule Elserver.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elserver,
      version: "0.1.0",
      description: "Small hackathon through elixir",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
        preferred_cli_env: [
          "coveralls": :test, 
          "coveralls.detail": :test, 
          "coveralls.post": :test, 
          "coveralls.html": :test
        ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Elserver, []},
      env: [port: 3000]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps() do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.12.0"},
      {:hackney, "~> 1.8.0", override: true},
      {:excoveralls, "~> 0.7", only: :test}
    ]
  end
end
