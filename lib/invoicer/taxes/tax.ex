defmodule Invoicer.Taxes.Tax do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "taxes" do
    field :active, :boolean, default: false
    field :amount, :float
    field :category, :string
    field :computation, :string
    field :included, :boolean, default: false
    field :name, :string
    field :scope, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(tax, attrs) do
    tax
    |> cast(attrs, [:name, :category, :active, :type, :scope, :computation, :amount, :included])
    |> validate_required([:name, :category, :active, :type, :scope, :computation, :amount, :included])
    |> validate_inclusion(:computation, ["percentage", "value"])
    |> validate_inclusion(:scope, ["item", "invoice"])
    |> validate_inclusion(:type, ["sale", "purchase", "both", "other"])
  end
end
