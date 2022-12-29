defmodule Invoicer.Partners.Partner do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "partners" do
    field :active, :boolean, default: true
    field :address_ids, {:array, :string}
    field :bank_account_ids, {:array, :string}
    field :my_company, :boolean, default: false
    field :name, :string
    field :payment_method, :string
    field :payment_term, :integer, default: 0
    field :type, :string
    field :vatnumber, :string
    field :currency_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(partner, attrs) do
    partner
    |> cast(attrs, [:my_company, :name, :active, :type, :vatnumber, :bank_account_ids, :payment_term, :payment_method, :address_ids, :currency_id])
    |> validate_required([:my_company, :name])
    |> unique_constraint(:vatnumber)
    |> unique_constraint(:name)
    |> unique_constraint(:my_company)
  end
end
