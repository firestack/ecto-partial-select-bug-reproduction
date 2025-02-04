Mix.install(
	[
		{:ecto_sql, "~> 3.0"},
		{:postgrex, ">= 0.0.0"}
	],
	config: [
		test: [
			{Test.Repo,
			 [
				 database: "repo_select_test",
				 pool: Ecto.Adapters.SQL.Sandbox
			 ]}
		]
	]
)

defmodule Test.Repo do
	use Ecto.Repo,
		otp_app: :test,
		adapter: Ecto.Adapters.Postgres
end

{:ok, _pid} = Test.Repo.start_link()

defmodule Test.Migrations.CreateTables do
	use Ecto.Migration

	def change do
		create table(:users) do
			add(:x, :integer)
		end

		create table(:detours) do
			add(:y, :integer)
			add(:user_id, references(:users))
		end
	end
end

defmodule Test.User do
	use Ecto.Schema

	schema "users" do
		field(:x, :integer)
		has_many(:detours, Test.Detour)
	end
end

defmodule Test.Detour do
	use Ecto.Schema

	schema "detours" do
		field(:y, :integer)
		belongs_to(:user, Test.User)
	end
end

Ecto.Adapters.SQL.Sandbox.mode(Test.Repo, :manual)
ExUnit.start()

# 2) Create a new test module (test case) and use "ExUnit.Case".
defmodule Tests do
	use ExUnit.Case

	# import Ecto
	import Ecto.Query

	alias Test.Repo
	alias Test.User
	alias Test.Detour

	setup tags do
		pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Test.Repo, shared: not tags[:async])
		on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
		:ok
	end

	test "baseline: can insert and retrieve from DB" do
		%User{id: id} = Repo.insert!(%User{})
		%User{id: ^id} = Repo.get!(User, id)
	end

	test "bug: cannot partial select structs without id" do
		Repo.insert!(%User{
			x: 1,
			detours: [
				%Detour{
					y: 2
				}
			]
		})

		%Detour{y: 2, id: nil, user: %User{id: nil, x: 1}} =
			from(
				d in Detour,
				join: u in assoc(d, :user),
				preload: [user: u],
				select: [:y, user: [:x]]
				# select: %Detour{y: d.y, user: u}
			)
			|> Repo.one!()
	end

	test "bug: cannot partial select structs without id: 2" do
		Repo.insert!(%User{
			x: 1,
			detours: [
				%Detour{
					y: 2
				}
			]
		})

		%Detour{y: 2, id: nil, user: %User{id: nil, x: 1}} =
			from(Detour, as: :detour)
			|> join(:left, [detour: d], assoc(d, :user), as: :user)
			|> preload([user: u], user: u)
			|> select([detour: d, user: u], %Detour{y: d.y, user: u})
			# |> select([detour: d, user: u], %Detour{y: d.y, user: %User{x: u.x}})
			|> Repo.one!()
	end

	test "bug counterexample: can partial select, if id's are included for all structs and preloads" do
		%User{id: user_id, detours: [%Detour{id: detour_id}]} =
			Repo.insert!(%User{
				x: 1,
				detours: [
					%Detour{
						y: 2
					}
				]
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
