defmodule Invoicer.Bank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bank_accounts" do
    field :name, :string
    field :number, :string
    field :currency_id, :binary_id
    field :partner_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :number, :currency_id, :partner_id])
    |> validate_required([:name, :number, :currency_id])
    |> unique_constraint(:number)
  end
end
