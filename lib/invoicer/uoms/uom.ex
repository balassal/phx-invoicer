defmodule Invoicer.Uoms.Uom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "uoms" do
    field :label, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(uom, attrs) do
    uom
    |> cast(attrs, [:name, :label])
    |> validate_required([:name, :label])
  end
end
