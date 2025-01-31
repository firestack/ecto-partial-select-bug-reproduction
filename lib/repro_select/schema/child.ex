defmodule ReproSelect.Schema.Child do
	use Ecto.Schema

	schema "parent" do
	  field :x, :integer
	  belongs_to :parent, ReproSelect.Schema.Parent
	end
end
