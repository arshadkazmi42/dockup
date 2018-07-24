defmodule FakeDockup.Mixfile do
  use Mix.Project

  def project do
    [
      app: :fake_dockup,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :dogstatsd]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dockup_spec, in_umbrella: true},
      {:dogstatsd, "0.0.3"}
    ]
  end
end
