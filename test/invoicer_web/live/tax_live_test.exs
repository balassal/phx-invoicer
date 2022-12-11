defmodule InvoicerWeb.TaxLiveTest do
  use InvoicerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Invoicer.TaxesFixtures

  @create_attrs %{active: true, amount: 120.5, category: "some category", computation: "percentage", included: true, name: "some name", scope: "item", type: "sale"}
  @update_attrs %{active: false, amount: 456.7, category: "some updated category", computation: "percentage", included: false, name: "some updated name", scope: "invoice", type: "sale"}
  @invalid_attrs %{active: false, amount: nil, category: nil, computation: "percentage", included: false, name: nil, scope: "item", type: "sale"}

  defp create_tax(_) do
    tax = tax_fixture()
    %{tax: tax}
  end

  describe "Index" do
    setup [:create_tax]

    test "lists all taxes", %{conn: conn, tax: tax} do
      {:ok, _index_live, html} = live(conn, ~p"/settings/taxes")

      assert html =~ "Listing Taxes"
      assert html =~ tax.category
    end

    test "saves new tax", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/taxes")

      assert index_live |> element("a", "New Tax") |> render_click() =~
               "New Tax"

      assert_patch(index_live, ~p"/settings/taxes/new")

      assert index_live
             |> form("#tax-form", tax: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tax-form", tax: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/taxes")

      assert html =~ "Tax created successfully"
      assert html =~ "some category"
    end

    test "updates tax in listing", %{conn: conn, tax: tax} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/taxes")

      assert index_live |> element("#taxes-#{tax.id} a", "Edit") |> render_click() =~
               "Edit Tax"

      assert_patch(index_live, ~p"/settings/taxes/#{tax}/edit")

      assert index_live
             |> form("#tax-form", tax: @invalid_attrs)
             |> render_change() =~ "percentage"

      {:ok, _, html} =
        index_live
        |> form("#tax-form", tax: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/taxes")

      assert html =~ "Tax updated successfully"
      assert html =~ "some updated category"
    end

    test "deletes tax in listing", %{conn: conn, tax: tax} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/taxes")

      assert index_live |> element("#taxes-#{tax.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tax-#{tax.id}")
    end
  end

  describe "Show" do
    setup [:create_tax]

    test "displays tax", %{conn: conn, tax: tax} do
      {:ok, _show_live, html} = live(conn, ~p"/settings/taxes/#{tax}")

      assert html =~ "Show Tax"
      assert html =~ tax.category
    end

    test "updates tax within modal", %{conn: conn, tax: tax} do
      {:ok, show_live, _html} = live(conn, ~p"/settings/taxes/#{tax}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tax"

      assert_patch(show_live, ~p"/settings/taxes/#{tax}/show/edit")

      assert show_live
             |> form("#tax-form", tax: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#tax-form", tax: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/taxes/#{tax}")

      assert html =~ "Tax updated successfully"
      assert html =~ "some updated category"
    end
  end
end
