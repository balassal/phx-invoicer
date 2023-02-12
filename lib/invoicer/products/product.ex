defmodule Invoicer.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :active, :boolean, default: true
    field :label, :string
    field :name, :string
    field :note, :string
    field :reference, :string
    field :type, :string
    field :unitprice, :decimal, default: 0
    field :uom_id, :binary_id
    field :saletaxes, {:array, :binary_id}
    field :purchasetaxes, {:array, :binary_id}
    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :label, :active, :type, :reference, :unitprice, :uom_id, :note, :saletaxes, :purchasetaxes])
    |> validate_required([:name, :type, :reference])
    |> unique_constraint(:name)
    |> unique_constraint(:reference)
  end
end
