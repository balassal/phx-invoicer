defmodule Invoicer.Repo.Migrations.AlterRateUniqueDate do
  use Ecto.Migration

  def change do
    create unique_index(:rates, [:date])
  end
end
