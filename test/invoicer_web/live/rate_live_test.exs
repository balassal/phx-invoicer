defmodule InvoicerWeb.RateLiveTest do
  use InvoicerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Invoicer.RatesFixtures

  @create_attrs %{date: "2022-12-10T15:36:00", exchange: "120.5"}
  @update_attrs %{date: "2022-12-11T15:36:00", exchange: "456.7"}
  @invalid_attrs %{date: nil, exchange: nil}

  defp create_rate(_) do
    rate = rate_fixture()
    %{rate: rate}
  end

  describe "Index" do
    setup [:create_rate]

    test "lists all rates", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/settings/rates")

      assert html =~ "Listing Rates"
    end

    test "saves new rate", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/rates")

      assert index_live |> element("a", "New Rate") |> render_click() =~
               "New Rate"

      assert_patch(index_live, ~p"/settings/rates/new")

      assert index_live
             |> form("#rate-form", rate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#rate-form", rate: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/rates")

      assert html =~ "Rate created successfully"
    end

    test "updates rate in listing", %{conn: conn, rate: rate} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/rates")

      assert index_live |> element("#rates-#{rate.id} a", "Edit") |> render_click() =~
               "Edit Rate"

      assert_patch(index_live, ~p"/settings/rates/#{rate}/edit")

      assert index_live
             |> form("#rate-form", rate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#rate-form", rate: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/rates")

      assert html =~ "Rate updated successfully"
    end

    test "deletes rate in listing", %{conn: conn, rate: rate} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/rates")

      assert index_live |> element("#rates-#{rate.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#rate-#{rate.id}")
    end
  end

  describe "Show" do
    setup [:create_rate]

    test "displays rate", %{conn: conn, rate: rate} do
      {:ok, _show_live, html} = live(conn, ~p"/settings/rates/#{rate}")

      assert html =~ "Show Rate"
    end

    test "updates rate within modal", %{conn: conn, rate: rate} do
      {:ok, show_live, _html} = live(conn, ~p"/settings/rates/#{rate}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Rate"

      assert_patch(show_live, ~p"/settings/rates/#{rate}/show/edit")

      assert show_live
             |> form("#rate-form", rate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#rate-form", rate: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/rates/#{rate}")

      assert html =~ "Rate updated successfully"
    end
  end
end
