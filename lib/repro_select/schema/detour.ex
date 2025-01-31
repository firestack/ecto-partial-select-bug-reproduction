defmodule ReproSelect.Schema.Detour do
	use Ecto.Schema

	schema "detour" do
		field :y, :integer
		belongs_to :user, ReproSelect.Schema.User
	end
end
