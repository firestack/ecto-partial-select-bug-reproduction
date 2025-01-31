defmodule ReproSelect.Schema.Parent do
	use Ecto.Schema

	schema "parent" do
	  field :x, :integer
	  has_one :assoc, ReproSelect.Schema.Child
	end
end
