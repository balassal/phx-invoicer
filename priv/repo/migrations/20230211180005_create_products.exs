defmodule Invoicer.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :label, :string
      add :active, :boolean, default: true, null: false
      add :type, :string
      add :reference, :string
      add :unitprice, :decimal, default: 0
      add :uom_id, :binary_id
      add :note, :string
      add :saletaxes, {:array, :binary_id}
      add :purchasetaxes, {:array, :binary_id}

      timestamps()
    end

    create unique_index(:products, [:name])
    create unique_index(:products, [:reference])
  end
end
