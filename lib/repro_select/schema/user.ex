defmodule ReproSelect.Schema.Parent do
	use Ecto.Schema

	schema "user" do
		field :x, :integer
		has_many :detours, ReproSelect.Schema.Detour
	end
end
