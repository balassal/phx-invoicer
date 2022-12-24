defmodule Invoicer.Repo.Migrations.AlterRateOnDeleteCurrency do
  use Ecto.Migration

  def change do
    alter table(:rates) do
      remove :currency_id
      add :currency_id, references(:currencies, on_delete: :nilify_all, type: :binary_id)
    end
  end
end
