# Used by "mix format"
[
	import_deps: [:ecto, :ecto_sql],
	plugins: [HendricksFormatter],
	inputs: [
		"{mix,.formatter}.exs",
		"{config,lib,test}/**/*.{ex,exs}",
		"{config,lib,test}/*.{ex,exs}",
		"priv/repo/migrations/*.exs"
	]
]
