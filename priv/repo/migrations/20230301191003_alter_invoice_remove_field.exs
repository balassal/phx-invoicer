defmodule Invoicer.Repo.Migrations.AlterInvoiceRemoveField do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      remove :invoice_line_ids
    end
  end
end
