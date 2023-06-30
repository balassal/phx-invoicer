defmodule Invoicer.Invoice.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "invoices" do
    field :amount, :decimal, default: Decimal.new(0)
    field :bank_account_id, Ecto.UUID
    field :currency_id, Ecto.UUID
    field :date, :date
    field :delivery_date, :date
    field :due_date, :date
    field :exchange_rate, :float, default: 1.0
    field :name, :string
    field :notes, :string
    field :partner_id, Ecto.UUID
    field :payment_method, :string
    field :payment_term, :integer
    field :rounding, :integer, default: 0
    field :state, :string
    field :tax_amount, :decimal, default: Decimal.new(0)
    field :to_be_paid, :decimal, default: Decimal.new(0)
    field :total, :decimal, default: Decimal.new(0)

    has_many :invoice_lines, Invoicer.Invoice.Lines.InvoiceLine

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:name, :partner_id, :date, :delivery_date, :due_date, :payment_term, :payment_method, :bank_account_id, :currency_id, :exchange_rate, :amount, :tax_amount, :total, :to_be_paid, :rounding, :notes, :state])
    |> cast_assoc(:invoice_lines)
    |> validate_required([:name, :partner_id])
    |> validate_change(:date, fn :date, date ->
      case Date.compare(date, Date.utc_today()) do
        :lt -> [{:date, "date should be today or later"}]
        _ -> []
      end
    end)
  end
end
