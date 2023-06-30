defmodule Invoicer.Repo.Migrations.AlterInvoiceLinesAddInvoiceId do
  use Ecto.Migration

  def change do
    alter table(:invoice_lines) do
      add :invoice_id, references(:invoices, on_delete: :delete_all, type: :binary_id)
    end
  end
end
