defmodule ReproSelect.MixProject do
	use Mix.Project

	def project do
		[
			app: :repro_select,
			version: "0.1.0",
			elixir: "~> 1.17",
			start_permanent: Mix.env() == :prod,
			elixirc_paths: elixirc_paths(Mix.env()),
			aliases: aliases(),
			deps: deps()
		]
	end

	# Run "mix help compile.app" to learn about applications.
	def application do
		[
			extra_applications: [:logger],
			mod: {ReproSelect.Application, []}
		]
	end

	# Run "mix help deps" to learn about dependencies.
	defp deps do
		[
			{:ecto_sql, "~> 3.0"},
			{:postgrex, ">= 0.0.0"}
		]
	end

	# Specifies which paths to compile per environment.
	defp elixirc_paths(:test), do: ["lib", "test/support"]
	defp elixirc_paths(_), do: ["lib"]

	defp aliases do
		[
			test: ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "test"]
		]
	end
end
