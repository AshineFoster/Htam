defmodule Htam.MixProject do
  use Mix.Project

  def project do
    [
      app: :htam,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      build_embedded: Mix.env == :prod,
      description: description(),
      package: package(),
      name: "Htam",
      source_url: "https://github.com/AshineFoster/Htam"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
    ]
  end

  defp description() do
    "A fork of the math package."
  end

  defp package() do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/AshineFoster/Htam"}
    ]
  end
end
