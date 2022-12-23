defmodule Invoicer.Addresses.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "addresses" do
    field :active, :boolean, default: false
    field :city, :string
    field :country, :string
    field :street, :string
    field :type, :string
    field :zip, :string

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:active, :street, :zip, :city, :country, :type])
    |> validate_required([:active, :street, :zip, :city, :country, :type])
  end
end
