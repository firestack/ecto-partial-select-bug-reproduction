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

		%Child{x: 2, id: nil, parent: %Parent{id: nil, x: 1}} =
			from(
				c in Child,
				join: p in assoc(c, :parent),
				preload: [parent: p],
				select: [:x, parent: [:x]]
			)
			|> Repo.one!()
	end


	test "bug repro with id" do
		Repo.insert!(%Parent{
			x: 1,
			assoc: %Child{
				x: 2
			}
		})

		%Child{x: 2, id: _, parent: %Parent{id: _, x: 1}} =
			from(
				c in Child,
				join: p in assoc(c, :parent),
				preload: [parent: p],
				select: [:id, :x, parent: [:id, :x]]
			)
			|> Repo.one!()
	end
end
