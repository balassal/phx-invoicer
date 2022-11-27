defmodule Invoicer.UomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Uoms` context.
  """

  @doc """
  Generate a uom.
  """
  def uom_fixture(attrs \\ %{}) do
    {:ok, uom} =
      attrs
      |> Enum.into(%{
        label: "some label",
        name: "some name"
      })
      |> Invoicer.Uoms.create_uom()

    uom
  end
end
