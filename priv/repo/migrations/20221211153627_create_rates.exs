defmodule Invoicer.Repo.Migrations.CreateRates do
  use Ecto.Migration

  def change do
    create table(:rates, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :naive_datetime
      add :exchange, :decimal

      timestamps()
    end
  end
end
