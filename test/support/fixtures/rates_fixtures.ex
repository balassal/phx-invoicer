defmodule Invoicer.RatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Rates` context.
  """

  alias Invoicer.CurrenciesFixtures

  @doc """
  Generate a rate.
  """
  def rate_fixture(attrs \\ %{}) do
    currency = CurrenciesFixtures.currency_fixture()
    {:ok, rate} =
      attrs
      |> Enum.into(%{
        date: ~N[2022-12-10 15:36:00],
        exchange: "120.5",
        currency_id: currency.id
      })
      |> Invoicer.Rates.create_rate()

    rate
  end
end
