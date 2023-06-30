defmodule Invoicer.Invoice.LinesTest do
  use Invoicer.DataCase

  alias Invoicer.Invoice.Lines

  describe "invoice_lines" do
    alias Invoicer.Invoice.Lines.InvoiceLine

    import Invoicer.Invoice.LinesFixtures

    @invalid_attrs %{amount: nil, label: nil, product_id: nil, quantity: nil, tax_amount: nil, tax_ids: nil, total: nil, unit_price: nil, uom_id: nil}

    test "list_invoice_lines/0 returns all invoice_lines" do
      invoice_line = invoice_line_fixture()
      assert Lines.list_invoice_lines() == [invoice_line]
    end

    test "get_invoice_line!/1 returns the invoice_line with given id" do
      invoice_line = invoice_line_fixture()
      assert Lines.get_invoice_line!(invoice_line.id) == invoice_line
    end

    test "create_invoice_line/1 with valid data creates a invoice_line" do
      valid_attrs = %{amount: "120.5", label: "some label", product_id: "7488a646-e31f-11e4-aace-600308960662", quantity: 120.5, tax_amount: "120.5", tax_ids: [], total: "120.5", unit_price: "120.5", uom_id: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %InvoiceLine{} = invoice_line} = Lines.create_invoice_line(valid_attrs)
      assert invoice_line.amount == Decimal.new("120.5")
      assert invoice_line.label == "some label"
      assert invoice_line.product_id == "7488a646-e31f-11e4-aace-600308960662"
      assert invoice_line.quantity == 120.5
      assert invoice_line.tax_amount == Decimal.new("120.5")
      assert invoice_line.tax_ids == []
      assert invoice_line.total == Decimal.new("120.5")
      assert invoice_line.unit_price == Decimal.new("120.5")
      assert invoice_line.uom_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_invoice_line/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lines.create_invoice_line(@invalid_attrs)
    end

    test "update_invoice_line/2 with valid data updates the invoice_line" do
      invoice_line = invoice_line_fixture()
      update_attrs = %{amount: "456.7", label: "some updated label", product_id: "7488a646-e31f-11e4-aace-600308960668", quantity: 456.7, tax_amount: "456.7", tax_ids: [], total: "456.7", unit_price: "456.7", uom_id: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %InvoiceLine{} = invoice_line} = Lines.update_invoice_line(invoice_line, update_attrs)
      assert invoice_line.amount == Decimal.new("456.7")
      assert invoice_line.label == "some updated label"
      assert invoice_line.product_id == "7488a646-e31f-11e4-aace-600308960668"
      assert invoice_line.quantity == 456.7
      assert invoice_line.tax_amount == Decimal.new("456.7")
      assert invoice_line.tax_ids == []
      assert invoice_line.total == Decimal.new("456.7")
      assert invoice_line.unit_price == Decimal.new("456.7")
      assert invoice_line.uom_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_invoice_line/2 with invalid data returns error changeset" do
      invoice_line = invoice_line_fixture()
      assert {:error, %Ecto.Changeset{}} = Lines.update_invoice_line(invoice_line, @invalid_attrs)
      assert invoice_line == Lines.get_invoice_line!(invoice_line.id)
    end

    test "delete_invoice_line/1 deletes the invoice_line" do
      invoice_line = invoice_line_fixture()
      assert {:ok, %InvoiceLine{}} = Lines.delete_invoice_line(invoice_line)
      assert_raise Ecto.NoResultsError, fn -> Lines.get_invoice_line!(invoice_line.id) end
    end

    test "change_invoice_line/1 returns a invoice_line changeset" do
      invoice_line = invoice_line_fixture()
      assert %Ecto.Changeset{} = Lines.change_invoice_line(invoice_line)
    end
  end
end
