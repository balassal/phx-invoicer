defmodule Invoicer.Bank.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoicer.Bank.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        name: "some name",
        number: "some number"
      })
      |> Invoicer.Bank.Accounts.create_account()

    account
  end
end
