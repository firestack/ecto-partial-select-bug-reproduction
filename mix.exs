defmodule ReproSelect.MixProject do
	use Mix.Project

	def project do
		[
			app: :repro_select,
			version: "0.1.0",
			elixir: "~> 1.17",
			start_permanent: Mix.env() == :prod,
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
			{:ecto_sqlite3, "~> 0.17"}
		]
	end
end
