defmodule Invoicer.RatesTest do
  use Invoicer.DataCase

  alias Invoicer.Rates

  describe "rates" do
    alias Invoicer.Rates.Rate

    import Invoicer.RatesFixtures

    @invalid_attrs %{date: nil, exchange: nil}

    test "list_rates/0 returns all rates" do
      rate = rate_fixture()
      assert Rates.list_rates() == [rate]
    end

    test "get_rate!/1 returns the rate with given id" do
      rate = rate_fixture()
      assert Rates.get_rate!(rate.id) == rate
    end

    test "create_rate/1 with valid data creates a rate" do
      valid_attrs = %{date: ~N[2022-12-10 15:36:00], exchange: "120.5"}

      assert {:ok, %Rate{} = rate} = Rates.create_rate(valid_attrs)
      assert rate.date == ~D[2022-12-10]
      assert rate.exchange == Decimal.new("120.5")
    end

    test "create_rate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rates.create_rate(@invalid_attrs)
    end

    test "update_rate/2 with valid data updates the rate" do
      rate = rate_fixture()
      update_attrs = %{date: ~N[2022-12-11 15:36:00], exchange: "456.7"}

      assert {:ok, %Rate{} = rate} = Rates.update_rate(rate, update_attrs)
      assert rate.date == ~D[2022-12-11]
      assert rate.exchange == Decimal.new("456.7")
    end

    test "update_rate/2 with invalid data returns error changeset" do
      rate = rate_fixture()
      assert {:error, %Ecto.Changeset{}} = Rates.update_rate(rate, @invalid_attrs)
      assert rate == Rates.get_rate!(rate.id)
    end

    test "delete_rate/1 deletes the rate" do
      rate = rate_fixture()
      assert {:ok, %Rate{}} = Rates.delete_rate(rate)
      assert_raise Ecto.NoResultsError, fn -> Rates.get_rate!(rate.id) end
    end

    test "change_rate/1 returns a rate changeset" do
      rate = rate_fixture()
      assert %Ecto.Changeset{} = Rates.change_rate(rate)
    end
  end
end
