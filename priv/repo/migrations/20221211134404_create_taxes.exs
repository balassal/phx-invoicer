defmodule Invoicer.Repo.Migrations.CreateTaxes do
  use Ecto.Migration

  def change do
    create table(:taxes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :category, :string
      add :active, :boolean, default: false, null: false
      add :type, :string
      add :scope, :string
      add :computation, :string
      add :amount, :float
      add :included, :boolean, default: false, null: false

      timestamps()
    end
  end
end
