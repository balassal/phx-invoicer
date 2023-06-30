defmodule Invoicer.Invoice.Lines.InvoiceLine do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "invoice_lines" do
    field :amount, :decimal, default: Decimal.new("0")
    field :label, :string
    field :product_id, :binary_id
    field :quantity, :float, default: 0.0
    field :tax_amount, :decimal, default: Decimal.new("0")
    field :tax_ids, {:array, :binary_id}
    field :total, :decimal, default: Decimal.new("0")
    field :unit_price, :decimal, default: Decimal.new("0")
    field :uom_id, :binary_id
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true

    belongs_to :invoice, Invoicer.Invoice.Invoices.Invoice

    timestamps()
  end

  @doc false
  def changeset(invoice_line, attrs) do
    invoice_line
    |> Map.put(:temp_id, (invoice_line.temp_id || attrs["temp_id"]))
    |> cast(attrs, [:label, :quantity, :uom_id, :unit_price, :tax_ids, :amount, :tax_amount, :total, :product_id, :invoice_id, :delete])
    |> validate_required([:label, :quantity, :unit_price])
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset
  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
