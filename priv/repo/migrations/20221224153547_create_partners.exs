defmodule Invoicer.Repo.Migrations.CreatePartners do
  use Ecto.Migration

  def change do
    create table(:partners, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :my_company, :boolean, default: false, null: false
      add :name, :string
      add :active, :boolean, default: false, null: false
      add :type, :string
      add :vatnumber, :string
      add :bank_account_ids, {:array, :string}
      add :payment_therm, :integer
      add :payment_method, :string
      add :address_ids, {:array, :string}
      add :currency_id, references(:currencies, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:partners, [:vatnumber])
    create unique_index(:partners, [:name])
    create unique_index(:partners, [:my_company])
    create index(:partners, [:currency_id])
  end
end
