import Config

config :repro_select, ReproSelect.Repo,
	database: "repo_select_test",
	pool: Ecto.Adapters.SQL.Sandbox
