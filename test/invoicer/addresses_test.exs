defmodule Invoicer.AddressesTest do
  use Invoicer.DataCase

  alias Invoicer.Addresses

  describe "addresses" do
    alias Invoicer.Addresses.Address

    import Invoicer.AddressesFixtures

    @invalid_attrs %{active: nil, city: nil, country: nil, street: nil, type: nil, zip: nil}

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Addresses.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Addresses.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      valid_attrs = %{active: true, city: "some city", country: "some country", street: "some street", type: "some type", zip: "some zip"}

      assert {:ok, %Address{} = address} = Addresses.create_address(valid_attrs)
      assert address.active == true
      assert address.city == "some city"
      assert address.country == "some country"
      assert address.street == "some street"
      assert address.type == "some type"
      assert address.zip == "some zip"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Addresses.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      update_attrs = %{active: false, city: "some updated city", country: "some updated country", street: "some updated street", type: "some updated type", zip: "some updated zip"}

      assert {:ok, %Address{} = address} = Addresses.update_address(address, update_attrs)
      assert address.active == false
      assert address.city == "some updated city"
      assert address.country == "some updated country"
      assert address.street == "some updated street"
      assert address.type == "some updated type"
      assert address.zip == "some updated zip"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Addresses.update_address(address, @invalid_attrs)
      assert address == Addresses.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Addresses.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Addresses.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Addresses.change_address(address)
    end
  end
end
