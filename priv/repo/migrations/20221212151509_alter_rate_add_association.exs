defmodule Invoicer.Repo.Migrations.AlterRateAddAssociation do
  use Ecto.Migration

  def change do
    alter table(:rates) do
      add :currency_id, references(:currencies, on_delete: :nothing, type: :binary_id)
    end

    create index(:rates, [:currency_id])
  end
end
