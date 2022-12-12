defmodule InvoicerWeb.CurrencyLiveTest do
  use InvoicerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Invoicer.CurrenciesFixtures

  @create_attrs %{label: "some label", name: "some name", symbol: "some symbol"}
  @update_attrs %{label: "some updated label", name: "some updated name", symbol: "some updated symbol"}
  @invalid_attrs %{label: nil, name: nil, symbol: nil}

  defp create_currency(_) do
    currency = currency_fixture()
    %{currency: currency}
  end

  describe "Index" do
    setup [:create_currency]

    test "lists all currencies", %{conn: conn, currency: currency} do
      {:ok, _index_live, html} = live(conn, ~p"/settings/currencies")

      assert html =~ "Listing Currencies"
      assert html =~ currency.label
    end

    test "saves new currency", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/currencies")

      assert index_live |> element("a", "New Currency") |> render_click() =~
               "New Currency"

      assert_patch(index_live, ~p"/settings/currencies/new")

      assert index_live
             |> form("#currency-form", currency: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#currency-form", currency: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/currencies")

      assert html =~ "Currency created successfully"
      assert html =~ "some label"
    end

    test "updates currency in listing", %{conn: conn, currency: currency} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/currencies")

      assert index_live |> element("#currencies-#{currency.id} a", "Edit") |> render_click() =~
               "Edit Currency"

      assert_patch(index_live, ~p"/settings/currencies/#{currency}/edit")

      assert index_live
             |> form("#currency-form", currency: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#currency-form", currency: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/currencies")

      assert html =~ "Currency updated successfully"
      assert html =~ "some updated label"
    end

    test "deletes currency in listing", %{conn: conn, currency: currency} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/currencies")

      assert index_live |> element("#currencies-#{currency.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#currency-#{currency.id}")
    end
  end

  describe "Show" do
    setup [:create_currency]

    test "displays currency", %{conn: conn, currency: currency} do
      {:ok, _show_live, html} = live(conn, ~p"/settings/currencies/#{currency}")

      assert html =~ "Show Currency"
      assert html =~ currency.label
    end

    test "updates currency within modal", %{conn: conn, currency: currency} do
      {:ok, show_live, _html} = live(conn, ~p"/settings/currencies/#{currency}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Currency"

      assert_patch(show_live, ~p"/settings/currencies/#{currency}/show/edit")

      assert show_live
             |> form("#currency-form", currency: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#currency-form", currency: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/currencies/#{currency}")

      assert html =~ "Currency updated successfully"
      assert html =~ "some updated label"
    end
  end
end
