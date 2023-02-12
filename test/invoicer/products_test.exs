defmodule Invoicer.ProductsTest do
  use Invoicer.DataCase

  alias Invoicer.Products
  alias Invoicer.UomsFixtures

  describe "products" do
    alias Invoicer.Products.Product

    import Invoicer.ProductsFixtures

    @invalid_attrs %{active: nil, label: nil, name: nil, note: nil, reference: nil, type: nil, unitprice: nil, uom_id: nil}

    test "list_products/0 returns all products" do
      uom = UomsFixtures.uom_fixture()
      product = product_fixture(uom_id: uom.id)
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      uom = UomsFixtures.uom_fixture()
      product = product_fixture(uom_id: uom.id)
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      uom = UomsFixtures.uom_fixture()
      valid_attrs = %{active: true, label: "some label", name: "some name", note: "some note", reference: "some reference", type: "some type", unitprice: "120.5", uom_id: uom.id}

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.active == true
      assert product.label == "some label"
      assert product.name == "some name"
      assert product.note == "some note"
      assert product.reference == "some reference"
      assert product.type == "some type"
      assert product.unitprice == Decimal.new("120.5")
      assert product.uom_id == uom.id
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      uom = UomsFixtures.uom_fixture()
      product = product_fixture(uom_id: uom.id)
      update_attrs = %{active: false, label: "some updated label", name: "some updated name", note: "some updated note", reference: "some updated reference", type: "some updated type", unitprice: "456.7", uom_id: uom.id}

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.active == false
      assert product.label == "some updated label"
      assert product.name == "some updated name"
      assert product.note == "some updated note"
      assert product.reference == "some updated reference"
      assert product.type == "some updated type"
      assert product.unitprice == Decimal.new("456.7")
      assert product.uom_id == uom.id
    end

    test "update_product/2 with invalid data returns error changeset" do
      uom = UomsFixtures.uom_fixture()
      product = product_fixture(uom_id: uom.id)
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      uom = UomsFixtures.uom_fixture()
      product = product_fixture(uom_id: uom.id)
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      uom = UomsFixtures.uom_fixture()
      product = product_fixture(uom_id: uom.id)
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
