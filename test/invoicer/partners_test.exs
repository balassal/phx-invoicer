defmodule Invoicer.PartnersTest do
  use Invoicer.DataCase

  alias Invoicer.Partners

  describe "partners" do
    alias Invoicer.Partners.Partner

    import Invoicer.PartnersFixtures

    @invalid_attrs %{active: nil, my_company: nil, name: nil, payment_method: nil, payment_term: nil, type: nil, vatnumber: nil}

    test "list_partners/0 returns all partners" do
      partner = partner_fixture()
      assert Partners.list_partners() == [partner]
    end

    test "get_partner!/1 returns the partner with given id" do
      partner = partner_fixture()
      assert Partners.get_partner!(partner.id) == partner
    end

    test "create_partner/1 with valid data creates a partner" do
      valid_attrs = %{active: true, my_company: true, name: "some name", payment_method: "some payment_method", payment_term: 42, type: "some type", vatnumber: "some vatnumber"}

      assert {:ok, %Partner{} = partner} = Partners.create_partner(valid_attrs)
      assert partner.active == true
      assert partner.my_company == true
      assert partner.name == "some name"
      assert partner.payment_method == "some payment_method"
      assert partner.payment_term == 42
      assert partner.type == "some type"
      assert partner.vatnumber == "some vatnumber"
    end

    test "create_partner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Partners.create_partner(@invalid_attrs)
    end

    test "update_partner/2 with valid data updates the partner" do
      partner = partner_fixture()
      update_attrs = %{active: false, my_company: false, name: "some updated name", payment_method: "some updated payment_method", payment_term: 43, type: "some updated type", vatnumber: "some updated vatnumber"}

      assert {:ok, %Partner{} = partner} = Partners.update_partner(partner, update_attrs)
      assert partner.active == false
      assert partner.my_company == false
      assert partner.name == "some updated name"
      assert partner.payment_method == "some updated payment_method"
      assert partner.payment_term == 43
      assert partner.type == "some updated type"
      assert partner.vatnumber == "some updated vatnumber"
    end

    test "update_partner/2 with invalid data returns error changeset" do
      partner = partner_fixture()
      assert {:error, %Ecto.Changeset{}} = Partners.update_partner(partner, @invalid_attrs)
      assert partner == Partners.get_partner!(partner.id)
    end

    test "delete_partner/1 deletes the partner" do
      partner = partner_fixture()
      assert {:ok, %Partner{}} = Partners.delete_partner(partner)
      assert_raise Ecto.NoResultsError, fn -> Partners.get_partner!(partner.id) end
    end

    test "change_partner/1 returns a partner changeset" do
      partner = partner_fixture()
      assert %Ecto.Changeset{} = Partners.change_partner(partner)
    end
  end
end
