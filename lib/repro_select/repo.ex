defmodule ReproSelect.Repo do
	use Ecto.Repo,
		otp_app: :repro_select,
		adapter: Ecto.Adapters.Postgres
end
