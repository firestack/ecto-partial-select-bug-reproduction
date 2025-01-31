defmodule ReproSelectTest do
	use ExUnit.Case
alias ReproSelect.Schema.Child
alias ReproSelect.Schema.Parent
	use ReproSelect.RepoCase

	test "baseline: can insert and retrieve from DB" do
		%Parent{id: id} = Repo.insert!(%Parent{})
		%Parent{id: ^id} = Repo.get!(Parent, id)
	end

	test "bug: cannot partial select structs without id" do
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


	test "bug counterexample: can partial select, if id's are included for all structs and preloads" do
		%Parent{id: parent_id, assoc: %Child{id: child_id}} = Repo.insert!(%Parent{
			x: 1,
			assoc: %Child{
				x: 2
			}
		})

		%Child{x: 2, id: ^child_id, parent: %Parent{id: ^parent_id, x: 1}} =
			from(
				c in Child,
				join: p in assoc(c, :parent),
				preload: [parent: p],
				select: [:id, :x, parent: [:id, :x]]
			)
			|> Repo.one!()
	end
end
