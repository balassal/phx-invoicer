defmodule Invoicer.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :active, :boolean, default: false, null: false
      add :street, :string
      add :zip, :string
      add :city, :string
      add :country, :string
      add :type, :string

      timestamps()
    end
  end
end
