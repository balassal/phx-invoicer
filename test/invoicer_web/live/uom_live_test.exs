defmodule InvoicerWeb.UomLiveTest do
  use InvoicerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Invoicer.UomsFixtures

  @create_attrs %{label: "some label", name: "some name"}
  @update_attrs %{label: "some updated label", name: "some updated name"}
  @invalid_attrs %{label: nil, name: nil}

  defp create_uom(_) do
    uom = uom_fixture()
    %{uom: uom}
  end

  describe "Index" do
    setup [:create_uom]

    test "lists all uoms", %{conn: conn, uom: uom} do
      {:ok, _index_live, html} = live(conn, ~p"/settings/uoms")

      assert html =~ "Listing Uoms"
      assert html =~ uom.label
    end

    test "saves new uom", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/uoms")

      assert index_live |> element("a", "New Uom") |> render_click() =~
               "New Uom"

      assert_patch(index_live, ~p"/settings/uoms/new")

      assert index_live
             |> form("#uom-form", uom: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#uom-form", uom: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/uoms")

      assert html =~ "Uom created successfully"
      assert html =~ "some label"
    end

    test "updates uom in listing", %{conn: conn, uom: uom} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/uoms")

      assert index_live |> element("#uoms-#{uom.id} a", "Edit") |> render_click() =~
               "Edit"

      assert_patch(index_live, ~p"/settings/uoms/#{uom}/edit")

      assert index_live
             |> form("#uom-form", uom: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#uom-form", uom: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/uoms")

      assert html =~ "Uom updated successfully"
      assert html =~ "some updated label"
    end

    test "deletes uom in listing", %{conn: conn, uom: uom} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/uoms")

      assert index_live |> element("#uoms-#{uom.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#uom-#{uom.id}")
    end
  end

  describe "Show" do
    setup [:create_uom]

    test "displays uom", %{conn: conn, uom: uom} do
      {:ok, _show_live, html} = live(conn, ~p"/settings/uoms/#{uom}")

      assert html =~ "Show Uom"
      assert html =~ uom.label
    end

    test "updates uom within modal", %{conn: conn, uom: uom} do
      {:ok, show_live, _html} = live(conn, ~p"/settings/uoms/#{uom}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit"

      assert_patch(show_live, ~p"/settings/uoms/#{uom}/show/edit")

      assert show_live
             |> form("#uom-form", uom: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#uom-form", uom: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/uoms/#{uom}")

      assert html =~ "Uom updated successfully"
      assert html =~ "some updated label"
    end
  end
end
