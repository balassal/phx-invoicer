defmodule Invoicer.Repo.Migrations.AlterBankAccountsNumberUnique do
  use Ecto.Migration

  def change do
    create unique_index(:bank_accounts, [:number])
  end
end
