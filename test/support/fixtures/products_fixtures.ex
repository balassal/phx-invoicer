defmodule Invoicer.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Products` context.
  """

  @doc """
  Generate a unique product name.
  """
  def unique_product_name, do: "some name#{System.unique_integer([:positive])}"

  def unique_product_reference, do: "some reference#{System.unique_integer([:positive])}"


  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        active: true,
        label: "some label",
        name: unique_product_name(),
        note: "some note",
        reference: unique_product_reference(),
        type: "sale",
        unitprice: "120.5",
      })
      |> Invoicer.Products.create_product()

    product
  end
end
