import Config

config :repro_select,
	ecto_repos: [ReproSelect.Repo]

config :repro_select, ReproSelect.Repo,
	hostname: "localhost",
	database: "repo_select"

import_config "#{config_env()}.exs"
