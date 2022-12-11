defmodule Invoicer.TaxesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Taxes` context.
  """

  @doc """
  Generate a tax.
  """
  def tax_fixture(attrs \\ %{}) do
    {:ok, tax} =
      attrs
      |> Enum.into(%{
        active: true,
        amount: "120.5",
        category: "some category",
        computation: "percentage",
        included: true,
        name: "some name",
        scope: "invoice",
        type: "sale"
      })
      |> Invoicer.Taxes.create_tax()

    tax
  end
end
