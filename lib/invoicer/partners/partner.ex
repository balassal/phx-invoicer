defmodule Invoicer.Partners.Partner do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "partners" do
    field :active, :boolean, default: true
    field :my_company, :boolean, default: false
    field :name, :string
    field :payment_method, :string
    field :payment_term, :integer, default: 0
    field :type, :string
    field :vatnumber, :string
    has_one :currency, Invoicer.Currencies.Currency
    has_many :addresses, Invoicer.Addresses.Address

    timestamps()
  end

  @doc false
  def changeset(partner, attrs) do
    partner
    |> cast(attrs, [:my_company, :name, :active, :type, :vatnumber, :payment_term, :payment_method])
    |> validate_required([:my_company, :name])
    |> unique_constraint(:vatnumber)
    |> unique_constraint(:name)
    |> unique_constraint(:my_company)
  end
end
