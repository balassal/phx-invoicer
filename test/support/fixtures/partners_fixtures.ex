defmodule Invoicer.PartnersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Partners` context.
  """

  @doc """
  Generate a unique partner my_company.
  """
  def unique_partner_my_company do
    :false
  end

  @doc """
  Generate a unique partner name.
  """
  def unique_partner_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique partner vatnumber.
  """
  def unique_partner_vatnumber, do: "some vatnumber#{System.unique_integer([:positive])}"

  @doc """
  Generate a partner.
  """
  def partner_fixture(attrs \\ %{}) do
    {:ok, partner} =
      attrs
      |> Enum.into(%{
        active: true,
        my_company: unique_partner_my_company(),
        name: unique_partner_name(),
        payment_method: "some payment_method",
        payment_term: 42,
        type: "some type",
        vatnumber: unique_partner_vatnumber(),
      })
      |> Invoicer.Partners.create_partner()

    partner
  end
end
