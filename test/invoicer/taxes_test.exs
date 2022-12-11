defmodule Invoicer.TaxesTest do
  use Invoicer.DataCase

  alias Invoicer.Taxes

  describe "taxes" do
    alias Invoicer.Taxes.Tax

    import Invoicer.TaxesFixtures

    @invalid_attrs %{active: nil, amount: nil, category: nil, computation: nil, included: nil, name: nil, scope: nil, type: nil}

    test "list_taxes/0 returns all taxes" do
      tax = tax_fixture()
      assert Taxes.list_taxes() == [tax]
    end

    test "get_tax!/1 returns the tax with given id" do
      tax = tax_fixture()
      assert Taxes.get_tax!(tax.id) == tax
    end

    test "create_tax/1 with valid data creates a tax" do
      valid_attrs = %{active: true, amount: 120.5, category: "some category", computation: "value", included: true, name: "some name", scope: "item", type: "sale"}

      assert {:ok, %Tax{} = tax} = Taxes.create_tax(valid_attrs)
      assert tax.active == true
      assert tax.amount == Decimal.new("120.5")
      assert tax.category == "some category"
      assert tax.computation == "value"
      assert tax.included == true
      assert tax.name == "some name"
      assert tax.scope == "item"
      assert tax.type == "sale"
    end

    test "create_tax/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Taxes.create_tax(@invalid_attrs)
    end

    test "update_tax/2 with valid data updates the tax" do
      tax = tax_fixture()
      update_attrs = %{active: false, amount: 456.7, category: "some updated category", computation: "percentage", included: false, name: "some updated name", scope: "item", type: "purchase"}

      assert {:ok, %Tax{} = tax} = Taxes.update_tax(tax, update_attrs)
      assert tax.active == false
      assert tax.amount == Decimal.new("456.7")
      assert tax.category == "some updated category"
      assert tax.computation == "percentage"
      assert tax.included == false
      assert tax.name == "some updated name"
      assert tax.scope == "item"
      assert tax.type == "purchase"
    end

    test "update_tax/2 with invalid data returns error changeset" do
      tax = tax_fixture()
      assert {:error, %Ecto.Changeset{}} = Taxes.update_tax(tax, @invalid_attrs)
      assert tax == Taxes.get_tax!(tax.id)
    end

    test "delete_tax/1 deletes the tax" do
      tax = tax_fixture()
      assert {:ok, %Tax{}} = Taxes.delete_tax(tax)
      assert_raise Ecto.NoResultsError, fn -> Taxes.get_tax!(tax.id) end
    end

    test "change_tax/1 returns a tax changeset" do
      tax = tax_fixture()
      assert %Ecto.Changeset{} = Taxes.change_tax(tax)
    end
  end
end
