defmodule Invoicer.Invoice.InvoicesTest do
  use Invoicer.DataCase

  alias Invoicer.Invoice.Invoices

  describe "invoices" do
    alias Invoicer.Invoice.Invoices.Invoice

    import Invoicer.Invoice.InvoicesFixtures

    @invalid_attrs %{amount: nil, bank_account_id: nil, currency_id: nil, date: nil, delivery_date: nil, due_date: nil, exchange_rate: nil, name: nil, notes: nil, partner_id: nil, payment_method: nil, payment_term: nil, rounding: nil, state: nil, tax_amount: nil, to_be_paid: nil, total: nil}

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Invoices.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Invoices.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      valid_attrs = %{amount: "120.5", bank_account_id: "7488a646-e31f-11e4-aace-600308960662", currency_id: "7488a646-e31f-11e4-aace-600308960662", date: ~D[2023-02-18], delivery_date: ~D[2023-02-18], due_date: ~D[2023-02-18], exchange_rate: 120.5, name: "some name", notes: "some notes", partner_id: "7488a646-e31f-11e4-aace-600308960662", payment_method: "some payment_method", payment_term: 42, rounding: 42, state: "some state", tax_amount: "120.5", to_be_paid: "120.5", total: "120.5"}

      assert {:ok, %Invoice{} = invoice} = Invoices.create_invoice(valid_attrs)
      assert invoice.amount == Decimal.new("120.5")
      assert invoice.bank_account_id == "7488a646-e31f-11e4-aace-600308960662"
      assert invoice.currency_id == "7488a646-e31f-11e4-aace-600308960662"
      assert invoice.date == ~D[2023-02-18]
      assert invoice.delivery_date == ~D[2023-02-18]
      assert invoice.due_date == ~D[2023-02-18]
      assert invoice.exchange_rate == 120.5
      assert invoice.name == "some name"
      assert invoice.notes == "some notes"
      assert invoice.partner_id == "7488a646-e31f-11e4-aace-600308960662"
      assert invoice.payment_method == "some payment_method"
      assert invoice.payment_term == 42
      assert invoice.rounding == 42
      assert invoice.state == "some state"
      assert invoice.tax_amount == Decimal.new("120.5")
      assert invoice.to_be_paid == Decimal.new("120.5")
      assert invoice.total == Decimal.new("120.5")
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoices.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      update_attrs = %{amount: "456.7", bank_account_id: "7488a646-e31f-11e4-aace-600308960668", currency_id: "7488a646-e31f-11e4-aace-600308960668", date: ~D[2023-02-19], delivery_date: ~D[2023-02-19], due_date: ~D[2023-02-19], exchange_rate: 456.7, name: "some updated name", notes: "some updated notes", partner_id: "7488a646-e31f-11e4-aace-600308960668", payment_method: "some updated payment_method", payment_term: 43, rounding: 43, state: "some updated state", tax_amount: "456.7", to_be_paid: "456.7", total: "456.7"}

      assert {:ok, %Invoice{} = invoice} = Invoices.update_invoice(invoice, update_attrs)
      assert invoice.amount == Decimal.new("456.7")
      assert invoice.bank_account_id == "7488a646-e31f-11e4-aace-600308960668"
      assert invoice.currency_id == "7488a646-e31f-11e4-aace-600308960668"
      assert invoice.date == ~D[2023-02-19]
      assert invoice.delivery_date == ~D[2023-02-19]
      assert invoice.due_date == ~D[2023-02-19]
      assert invoice.exchange_rate == 456.7
      assert invoice.name == "some updated name"
      assert invoice.notes == "some updated notes"
      assert invoice.partner_id == "7488a646-e31f-11e4-aace-600308960668"
      assert invoice.payment_method == "some updated payment_method"
      assert invoice.payment_term == 43
      assert invoice.rounding == 43
      assert invoice.state == "some updated state"
      assert invoice.tax_amount == Decimal.new("456.7")
      assert invoice.to_be_paid == Decimal.new("456.7")
      assert invoice.total == Decimal.new("456.7")
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Invoices.update_invoice(invoice, @invalid_attrs)
      assert invoice == Invoices.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Invoices.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Invoices.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Invoices.change_invoice(invoice)
    end
  end
end
