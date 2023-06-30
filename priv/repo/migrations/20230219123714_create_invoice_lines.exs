defmodule Invoicer.Repo.Migrations.CreateInvoiceLines do
  use Ecto.Migration

  def change do
    create table(:invoice_lines, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :label, :string
      add :quantity, :float
      add :uom_id, :binary_id
      add :unit_price, :decimal
      add :tax_ids, {:array, :binary_id}
      add :amount, :decimal
      add :tax_amount, :decimal
      add :total, :decimal
      add :product_id, :binary_id

      timestamps()
    end
  end
end
