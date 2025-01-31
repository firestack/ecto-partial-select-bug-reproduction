import Config

config :repro_select,
	ecto_repos: [ReproSelect.Repo]

config :repro_select, ReproSelect.Repo,
	database: "tmp/database.db"

# config :repro_select, ReproSelect.Repo,
# 	database: "repro_select_repo",
# 	username: "user",
# 	password: "pass",
# 	hostname: "localhost"
