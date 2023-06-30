defmodule Invoicer.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :partner_id, :uuid
      add :date, :date
      add :delivery_date, :date
      add :due_date, :date
      add :payment_term, :integer
      add :payment_method, :string
      add :bank_account_id, :uuid
      add :currency_id, :uuid
      add :exchange_rate, :float
      add :amount, :decimal
      add :tax_amount, :decimal
      add :total, :decimal
      add :to_be_paid, :decimal
      add :rounding, :integer
      add :invoice_line_ids, {:array, :uuid}
      add :notes, :string
      add :state, :string

      timestamps()
    end
  end
end
