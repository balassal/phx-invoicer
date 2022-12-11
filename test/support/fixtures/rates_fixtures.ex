defmodule Invoicer.RatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Rates` context.
  """

  @doc """
  Generate a rate.
  """
  def rate_fixture(attrs \\ %{}) do
    {:ok, rate} =
      attrs
      |> Enum.into(%{
        date: ~N[2022-12-10 15:36:00],
        exchange: "120.5"
      })
      |> Invoicer.Rates.create_rate()

    rate
  end
end
