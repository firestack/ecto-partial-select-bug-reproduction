defmodule :"Elixir.ReproSelect.Repo.Migrations.Create tables" do
  use Ecto.Migration

  def change do
	create table :parent do
add :x, :integer

	end

	create table :child do

add :x, :integer
	end
  end
end
