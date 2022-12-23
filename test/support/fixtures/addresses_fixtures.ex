defmodule Invoicer.AddressesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Addresses` context.
  """

  @doc """
  Generate a address.
  """
  def address_fixture(attrs \\ %{}) do
    {:ok, address} =
      attrs
      |> Enum.into(%{
        active: true,
        city: "some city",
        country: "some country",
        street: "some street",
        type: "some type",
        zip: "some zip"
      })
      |> Invoicer.Addresses.create_address()

    address
  end
end
