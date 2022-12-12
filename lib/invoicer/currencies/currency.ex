defmodule Invoicer.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "currencies" do
    field :label, :string
    field :name, :string
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:label, :name, :symbol])
    |> validate_required([:label, :name, :symbol])
  end
end
