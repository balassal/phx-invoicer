defmodule Invoicer.Repo.Migrations.AlterRateDateType do
  use Ecto.Migration

  def change do
    alter table(:rates) do
      modify :date, :date
    end
  end
end
