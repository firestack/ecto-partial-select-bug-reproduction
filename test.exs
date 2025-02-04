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

#region Ecto

# Define Repo
defmodule Test.Repo do
	use Ecto.Repo,
		otp_app: :test,
		adapter: Ecto.Adapters.Postgres
end

# Create Database
# https://github.com/elixir-ecto/ecto/blob/v3.12.5/lib/mix/tasks/ecto.create.ex#L58
if System.get_env("DROP_DB") do
	Test.Repo.config()
	|> Test.Repo.__adapter__().storage_down()
	|> dbg()
end

Test.Repo.config()
|> Test.Repo.__adapter__().storage_up()
|> dbg()

IO.puts("\n#{String.duplicate("=", 80)}\n")

# Start Repo
{:ok, _pid} = Test.Repo.start_link()


# Define and run migrations
defmodule Test.Migrations.CreateTables do
	use Ecto.Migration

	def change do
		create table("my_schema") do
			add(:property, :integer)
		end

		create table("single_association") do
			add(:x, :integer)

			add(:my_schema_id, references("my_schema"))
		end

		create table("many_association") do
			add(:y, :integer)

			add(:my_schema_id, references("my_schema"))
		end
	end
end


Ecto.Migrator.up(Test.Repo, 20250204000002, Test.Migrations.CreateTables)

# Define Schemas
defmodule Test.Schemas.MySchema do
	use Ecto.Schema

	schema "my_schema" do
		field(:property, :integer)

		has_one(:one_assoc, Test.Schemas.SingleAssociation)
		# has_many(:many_assoc, Test.Schemas.ManyAssociation)
	end
end

defmodule Test.Schemas.SingleAssociation do
	use Ecto.Schema

	schema "single_association" do
		field(:x, :integer)

		belongs_to(:my_schema, Test.Schemas.MySchema)
	end
end


# defmodule Test.Schemas.ManyAssociation do
# 	use Ecto.Schema

# 	schema "many_association" do
# 		field(:y, :integer)

# 		belongs_to(:user, Test.User)
# 	end
# end

#endregion Ecto

#region ExUnit

# Configure and Start ExUnit application but don't run tests yet
ExUnit.start(
	# Print tests as they run
	trace: true,

	# Run Tests in order of definition
	seed: 0,

	# Don't run tests yet
	autorun: false
)

# Configure Ecto
Ecto.Adapters.SQL.Sandbox.mode(Test.Repo, :manual)

# Define Tests
defmodule Tests do
	use ExUnit.Case

	import Ecto.Query

	alias Test.Repo
	alias Test.Schemas.{
		MySchema,
		SingleAssociation
	}

	setup tags do
		pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Test.Repo, shared: not tags[:async])
		on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
		:ok
	end

	defp test_fixture() do
		%MySchema{
			property: Enum.random(0..100),
			one_assoc: %SingleAssociation{
				x: Enum.random(0..100)
			}
		}
		|> Repo.insert!()
	end

	test "baseline: can insert and retrieve from DB" do
		%MySchema{id: id} = test_fixture()
		%MySchema{id: ^id} = Repo.get!(MySchema, id)
	end

	# test "bug: cannot partial select structs without id" do
	# 	Repo.insert!(%User{
	# 		x: 1,
	# 		detours: [
	# 			%Detour{
	# 				y: 2
	# 			}
	# 		]
	# 	})

	# 	%Detour{y: 2, id: nil, user: %User{id: nil, x: 1}} =
	# 		from(
	# 			d in Detour,
	# 			join: u in assoc(d, :user),
	# 			preload: [user: u],
	# 			select: [:y, user: [:x]]
	# 		)
	# 		|> Repo.one!()
	# end

	# test "bug: cannot partial select structs without id: 2" do
	# 	Repo.insert!(%User{
	# 		x: 1,
	# 		detours: [
	# 			%Detour{
	# 				y: 2
	# 			}
	# 		]
	# 	})

	# 	%Detour{y: 2, id: nil, user: %User{id: nil, x: 1}} =
	# 		from(Detour, as: :detour)
	# 		|> join(:left, [detour: d], assoc(d, :user), as: :user)
	# 		|> preload([user: u], user: u)
	# 		|> select([detour: d, user: u], %Detour{y: d.y, user: u})
	# 		# |> select([detour: d, user: u], %Detour{y: d.y, user: %User{x: u.x}})
	# 		|> Repo.one!()
	# end

	# test "bug counterexample: can partial select, if id's are included for all structs and preloads" do
	# 	%MySchema{
	# 		id: id,
	# 		property: generated_property,
	# 		one_assoc: %{x: generated_x}
	# 	} = test_fixture()


	# 	%Detour{y: 2, id: ^detour_id, user: %MySchema{id: ^user_id, x: 1}} =
	# 		from(
	# 			d in Detour,
	# 			join: u in assoc(d, :user),
	# 			preload: [user: u],
	# 			select: [:id, :y, user: [:id, :x]]
	# 		)
	# 		|> Repo.one!()
	# end
end

# Run Tests
ExUnit.run()
