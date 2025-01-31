defmodule ReproSelectTest do
	use ExUnit.Case
alias ReproSelect.Schema.Child
alias ReproSelect.Schema.Parent
	use ReproSelect.RepoCase

	test "inserts and retreves" do
		%Parent{id: id} = Repo.insert!(%Parent{})
		%Parent{id: ^id} = Repo.get!(Parent, id)
	end

	test "bug repro" do
		Repo.insert!(%Parent{
			x: 1,
			assoc: %Child{
				x: 2
			}
		})

		%Parent{x: 1, id: nil, assoc: %Child{id: nil, x: 2}} = from(
			p in Parent,

			join: c in assoc(p, :child),
			preload: [assoc: c],

			select: [:x, assoc: [:x]]
		)
		|> Repo.one!()
	end
end
