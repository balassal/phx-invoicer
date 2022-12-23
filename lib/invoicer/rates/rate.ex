defmodule Invoicer.Rates.Rate do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rates" do
    field :date, :date
    field :exchange, :decimal
    field :currency_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(rate, attrs) do
    rate
    |> cast(attrs, [:date, :exchange, :currency_id])
    |> validate_required([:date, :exchange, :currency_id])
    |> unique_constraint(:date)
    |> foreign_key_constraint(:currency_id)
  end
end
