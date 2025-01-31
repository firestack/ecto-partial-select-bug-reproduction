defmodule :"Elixir.ReproSelect.Repo.Migrations.Rewrite-tables" do
	use Ecto.Migration

	def change do
		create table(:users) do
			add :x, :integer
		end

		create table(:detours) do
			add :y, :integer
			add :user_id, references(:users)
		end
	end
end
