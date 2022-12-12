defmodule Invoicer.CurrenciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Currencies` context.
  """

  @doc """
  Generate a currency.
  """
  def currency_fixture(attrs \\ %{}) do
    {:ok, currency} =
      attrs
      |> Enum.into(%{
        label: "some label",
        name: "some name",
        symbol: "some symbol"
      })
      |> Invoicer.Currencies.create_currency()

    currency
  end
end
