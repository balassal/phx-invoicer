defmodule Invoicer.Repo.Migrations.AlterCurrencyAddPartnerId do
  use Ecto.Migration

  def change do
    alter table(:currencies) do
      add :partner_id, references(:partners, on_delete: :nothing, type: :binary_id)
    end

    create index(:currencies, [:partner_id])
  end
end
