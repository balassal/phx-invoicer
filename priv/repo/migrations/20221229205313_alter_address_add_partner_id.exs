defmodule Invoicer.Repo.Migrations.AlterAddressAddPartnerId do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add :partner_id, references(:partners, on_delete: :nilify_all, type: :binary_id)
    end

    create index(:addresses, [:partner_id])
  end
end
