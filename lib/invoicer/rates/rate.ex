defmodule Invoicer.Rates.Rate do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rates" do
    field :date, :naive_datetime
    field :exchange, :decimal

    timestamps()
  end

  @doc false
  def changeset(rate, attrs) do
    rate
    |> cast(attrs, [:date, :exchange])
    |> validate_required([:date, :exchange])
  end
end
