defmodule Invoicer.Repo.Migrations.AlterTaxAmountType do
  use Ecto.Migration

  def change do
    alter table(:taxes) do
      modify :amount, :decimal
    end

  end
end
