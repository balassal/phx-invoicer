defmodule Invoicer.Repo.Migrations.CreateBankAccounts do
  use Ecto.Migration

  def change do
    create table(:bank_accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :number, :string
      add :currency_id, references(:currencies, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:bank_accounts, [:currency_id])
  end
end
