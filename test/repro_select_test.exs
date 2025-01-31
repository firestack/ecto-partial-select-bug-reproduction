defmodule ReproSelectTest do
	use ExUnit.Case
	alias ReproSelect.Schema.User
	alias ReproSelect.Schema.Detour
	use ReproSelect.RepoCase

	test "baseline: can insert and retrieve from DB" do
		%User{id: id} = Repo.insert!(%User{})
		%User{id: ^id} = Repo.get!(User, id)
	end

	test "bug: cannot partial select structs without id" do
		Repo.insert!(%User{
			x: 1,
			assoc: %Detour{
				x: 2
			}
		})

		%Detour{x: 2, id: nil, parent: %User{id: nil, x: 1}} =
			from(
				c in Child,
				join: p in assoc(c, :parent),
				preload: [parent: p],
				select: [:x, parent: [:x]]
			)
			|> Repo.one!()
	end

	test "bug counterexample: can partial select, if id's are included for all structs and preloads" do
		%User{id: parent_id, assoc: %Detour{id: child_id}} =
			Repo.insert!(%User{
				x: 1,
				assoc: %Detour{
					x: 2
				}
			})

		%Detour{x: 2, id: ^child_id, parent: %User{id: ^parent_id, x: 1}} =
			from(
				c in Child,
				join: p in assoc(c, :parent),
				preload: [parent: p],
				select: [:id, :x, parent: [:id, :x]]
			)
			|> Repo.one!()
	end
end
