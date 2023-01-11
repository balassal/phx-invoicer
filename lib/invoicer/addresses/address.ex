defmodule Invoicer.Addresses.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "addresses" do
    field :active, :boolean, default: true
    field :city, :string
    field :country, :string
    field :street, :string
    field :type, :string
    field :zip, :string
    field :partner_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:active, :street, :zip, :city, :country, :type, :partner_id])
    |> validate_required([:active, :street, :zip, :city, :country, :type])
  end
end
