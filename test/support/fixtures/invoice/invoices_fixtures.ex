defmodule Invoicer.Invoice.InvoicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Invoice.Invoices` context.
  """

  @doc """
  Generate a invoice.
  """
  def invoice_fixture(attrs \\ %{}) do
    {:ok, invoice} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        bank_account_id: "7488a646-e31f-11e4-aace-600308960662",
        currency_id: "7488a646-e31f-11e4-aace-600308960662",
        date: ~D[2023-02-18],
        delivery_date: ~D[2023-02-18],
        due_date: ~D[2023-02-18],
        exchange_rate: 120.5,
        name: "some name",
        notes: "some notes",
        partner_id: "7488a646-e31f-11e4-aace-600308960662",
        payment_method: "some payment_method",
        payment_term: 42,
        rounding: 42,
        state: "some state",
        tax_amount: "120.5",
        to_be_paid: "120.5",
        total: "120.5"
      })
      |> Invoicer.Invoice.Invoices.create_invoice()

    invoice
  end
end
