defmodule Invoicer.Bank.AccountsTest do
  use Invoicer.DataCase

  alias Invoicer.Bank.Accounts
  alias Invoicer.CurrenciesFixtures

  describe "bank_accounts" do
    alias Invoicer.Bank.Accounts.Account

    import Invoicer.Bank.AccountsFixtures

    @invalid_attrs %{name: nil, number: nil}

    test "list_bank_accounts/0 returns all bank_accounts" do
      currency = CurrenciesFixtures.currency_fixture()
      account = account_fixture(%{currency_id: currency.id})
      assert Accounts.list_bank_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      currency = CurrenciesFixtures.currency_fixture()
      account = account_fixture(%{currency_id: currency.id})
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      currency = CurrenciesFixtures.currency_fixture()
      valid_attrs = %{name: "some name", number: "some number", currency_id: currency.id}

      assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)
      assert account.name == "some name"
      assert account.number == "some number"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      currency = CurrenciesFixtures.currency_fixture()
      account = account_fixture(%{currency_id: currency.id})
      update_attrs = %{name: "some updated name", number: "some updated number", currency_id: currency.id}

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.name == "some updated name"
      assert account.number == "some updated number"
    end

    test "update_account/2 with invalid data returns error changeset" do
      currency = CurrenciesFixtures.currency_fixture()
      account = account_fixture(%{currency_id: currency.id})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      currency = CurrenciesFixtures.currency_fixture()
      account = account_fixture(%{currency_id: currency.id})
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      currency = CurrenciesFixtures.currency_fixture()
      account = account_fixture(%{currency_id: currency.id})
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
