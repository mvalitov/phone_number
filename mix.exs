defmodule PhoneNumber.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phone_number,
      version: "0.2.2",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      homepage_url: "https://hexdocs.pm/phone_number",
      source_url: "https://github.com/mvalitov/phone_number",
      description: "Library for validating international phone numbers. Based on Google's libphonenumber.",
      docs: [main: "readme",
          extras: ["README.md"]],
      deps: deps(),
      package: package()
    ]
  end

  def package do
    [name: :phone_number,
     files: ["lib", "data", "mix.exs"],
     maintainers: ["Marsel Valitov"],
     licenses: ["MIT"],
     links: %{"Github" => "https://github.com/mvalitov/phone_number"}]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {PhoneNumber.Application, []}
    ]
  end

  defp deps do
    [
      {:sweet_xml, "~> 0.6.5"},
      {:fastglobal, "~> 1.0"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
