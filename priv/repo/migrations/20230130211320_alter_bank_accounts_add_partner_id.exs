defmodule Invoicer.Repo.Migrations.AlterBankAccountsAddPartnerId do
  use Ecto.Migration

  def change do
    alter table(:bank_accounts) do
      add :partner_id, references(:partners, on_delete: :nilify_all, type: :binary_id)
    end

    create index(:bank_accounts, [:partner_id])
  end
end
