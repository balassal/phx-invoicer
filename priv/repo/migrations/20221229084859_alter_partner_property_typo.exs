defmodule Invoicer.Repo.Migrations.AlterPartnerPropertyTypo do
  use Ecto.Migration

  def change do
    alter table(:partners) do
      remove :payment_therm
      add :payment_term, :integer
    end
  end
end
