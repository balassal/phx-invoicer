defmodule Invoicer.UomsTest do
  use Invoicer.DataCase

  alias Invoicer.Uoms

  describe "uoms" do
    alias Invoicer.Uoms.Uom

    import Invoicer.UomsFixtures

    @invalid_attrs %{label: nil, name: nil}

    test "list_uoms/0 returns all uoms" do
      uom = uom_fixture()
      assert Uoms.list_uoms() == [uom]
    end

    test "get_uom!/1 returns the uom with given id" do
      uom = uom_fixture()
      assert Uoms.get_uom!(uom.id) == uom
    end

    test "create_uom/1 with valid data creates a uom" do
      valid_attrs = %{label: "some label", name: "some name"}

      assert {:ok, %Uom{} = uom} = Uoms.create_uom(valid_attrs)
      assert uom.label == "some label"
      assert uom.name == "some name"
    end

    test "create_uom/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Uoms.create_uom(@invalid_attrs)
    end

    test "update_uom/2 with valid data updates the uom" do
      uom = uom_fixture()
      update_attrs = %{label: "some updated label", name: "some updated name"}

      assert {:ok, %Uom{} = uom} = Uoms.update_uom(uom, update_attrs)
      assert uom.label == "some updated label"
      assert uom.name == "some updated name"
    end

    test "update_uom/2 with invalid data returns error changeset" do
      uom = uom_fixture()
      assert {:error, %Ecto.Changeset{}} = Uoms.update_uom(uom, @invalid_attrs)
      assert uom == Uoms.get_uom!(uom.id)
    end

    test "delete_uom/1 deletes the uom" do
      uom = uom_fixture()
      assert {:ok, %Uom{}} = Uoms.delete_uom(uom)
      assert_raise Ecto.NoResultsError, fn -> Uoms.get_uom!(uom.id) end
    end

    test "change_uom/1 returns a uom changeset" do
      uom = uom_fixture()
      assert %Ecto.Changeset{} = Uoms.change_uom(uom)
    end
  end
end
