defmodule Invoicer.Repo.Migrations.AlterPartnerRemoveFields do
  use Ecto.Migration

  def change do
    alter table(:partners) do
      remove :address_ids
      remove :bank_account_ids
    end
  end
end
