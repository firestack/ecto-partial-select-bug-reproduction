defmodule ReproSelect.RepoCase do
	use ExUnit.CaseTemplate

	using do
		quote do
			alias ReproSelect.Repo

			import Ecto
			import Ecto.Query
			import ReproSelect.RepoCase

			# and any other stuff
		end
	end

	setup tags do
		pid = Ecto.Adapters.SQL.Sandbox.start_owner!(ReproSelect.Repo, shared: not tags[:async])
		on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
		:ok
	end
end
