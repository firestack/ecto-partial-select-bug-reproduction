defmodule ReproSelect do
	@moduledoc """
	Documentation for `ReproSelect`.
	"""

			alias ReproSelect.Repo
alias ReproSelect.Schema.User
alias ReproSelect.Schema.Detour

			import Ecto.Query
	@doc """
	Hello world.

	## Examples

			iex> ReproSelect.hello()
			:world

	"""
	def hello do

		Repo.insert!(%User{
			x: 2,
			detours: [%Detour{
				y: 3
			}]
		})

		# %Detour{y: 2, id: nil, user: %User{id: nil, x: 1}} =
			from(
				d in Detour,
				join: u in assoc(d, :user),
				preload: [user: u],
				select: [:y, user: [:x]]
				# select: %Detour{y: d.y, user: u}
			)
			|> Repo.all()
			|> dbg()
	end
end
