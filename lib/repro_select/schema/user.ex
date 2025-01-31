defmodule ReproSelect.Schema.User do
	use Ecto.Schema

	schema "users" do
		field :x, :integer
		has_many :detours, ReproSelect.Schema.Detour
	end
end
