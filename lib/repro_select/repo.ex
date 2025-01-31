defmodule ReproSelect.Repo do
	adapter: Ecto.Adapters.Postgres
	use Ecto.Repo,
		otp_app: :repro_select,
end
