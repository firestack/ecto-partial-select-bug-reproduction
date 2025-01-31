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
			detours: [%Detour{
				y: 2
			}]
		})

		%Detour{y: 2, id: nil, user: %User{id: nil, x: 1}} =
			from(
				c in Detour,
				join: p in assoc(c, :user),
				preload: [user: p],
				select: [:y, user: [:x]]
			)
			|> Repo.one!()
	end

	test "bug counterexample: can partial select, if id's are included for all structs and preloads" do
		%User{id: user_id, detours: [%Detour{id: detour_id}]} =
			Repo.insert!(%User{
				x: 1,
				detours: [%Detour{
					y: 2
				}]
			})

		%Detour{y: 2, id: ^detour_id, user: %User{id: ^user_id, x: 1}} =
			from(
				d in Detour,
				join: u in assoc(d, :user),
				preload: [user: u],
				select: [:id, :y, user: [:id, :x]]
			)
			|> Repo.one!()
	end
end
