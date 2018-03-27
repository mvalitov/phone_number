defmodule PhoneNumber.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phone_number,
      version: "0.1.2",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      homepage_url: "https://hexdocs.pm/phone_number",
      source_url: "https://github.com/mvalitov/phone_number",
      description: "Library for validating international phone numbers. Based on Google's libphonenumber.",
      docs: [main: "readme", # The main page in the docs
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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PhoneNumber.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:sweet_xml, "~> 0.6.5"},
      {:fastglobal, "~> 1.0"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
