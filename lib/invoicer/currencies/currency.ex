defmodule Invoicer.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset
  alias Invoicer.Rates.Rate

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "currencies" do
    field :label, :string
    field :name, :string
    field :symbol, :string
    field :partner_id, :binary_id
    has_many :rates, Rate

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:label, :name, :symbol, :partner_id])
    |> validate_required([:label, :name, :symbol])
  end
end
