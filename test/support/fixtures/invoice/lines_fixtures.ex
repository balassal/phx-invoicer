defmodule Invoicer.Invoice.LinesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Invoice.Lines` context.
  """

  @doc """
  Generate a invoice_line.
  """
  def invoice_line_fixture(attrs \\ %{}) do
    {:ok, invoice_line} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        label: "some label",
        product_id: "7488a646-e31f-11e4-aace-600308960662",
        quantity: 120.5,
        tax_amount: "120.5",
        tax_ids: [],
        total: "120.5",
        unit_price: "120.5",
        uom_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Invoicer.Invoice.Lines.create_invoice_line()

    invoice_line
  end
end
