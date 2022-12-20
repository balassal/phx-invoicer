defmodule InvoicerWeb.RateLiveTest do
  use InvoicerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Invoicer.RatesFixtures

  @create_attrs %{date: "2022-12-10T15:36:00", exchange: "120.5", currency_id: "6fe7f4b6-45af-4506-ae36-f94ee79e156e"}
  @update_attrs %{date: "2022-12-11T15:36:00", exchange: "456.7", currency_id: "6fe7f4b6-45af-4506-ae36-f94ee79e156e"}
  @invalid_attrs %{date: nil, exchange: nil, currency_id: nil}

  defp create_rate(_) do
    rate = rate_fixture()
    %{rate: rate}
  end

  describe "Index" do
    setup [:create_rate]

    test "lists all rates", %{conn: conn, rate: rate} do
      {:ok, _index_live, html} = live(conn, ~p"/settings/currencies/#{rate.currency_id}/rates")

      assert html =~ "Listing Rates"
    end

    test "saves new rate", %{conn: conn, rate: rate} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/currencies/#{rate.currency_id}/rates")

      assert index_live |> element("a", "New Rate") |> render_click() =~
               "New Rate"

      assert_patch(index_live, ~p"/settings/currencies/#{rate.currency_id}/rates/new")

      invalid_attrs = %{ @invalid_attrs | currency_id: rate.currency_id }
      assert index_live
             |> form("#rate-form", rate: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      create_attrs = %{ @create_attrs | currency_id: rate.currency_id }
      {:ok, _, html} =
        index_live
        |> form("#rate-form", rate: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/currencies/#{rate.currency_id}/rates")

      assert html =~ "Rate created successfully"
    end

    test "updates rate in listing", %{conn: conn, rate: rate} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/currencies/#{rate.currency_id}/rates")

      assert index_live |> element("#rates-#{rate.id} a[id=#{rate.id}_edit]") |> render_click() =~
               "Edit Rate"

      assert_patch(index_live, ~p"/settings/currencies/#{rate.currency_id}/rates/#{rate}/edit")

      invalid_attrs = %{ @invalid_attrs | currency_id: rate.currency_id }
      assert index_live
             |> form("#rate-form", rate: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      update_attrs = %{ @update_attrs | currency_id: rate.currency_id }
      {:ok, _, html} =
        index_live
        |> form("#rate-form", rate: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/currencies/#{rate.currency_id}/rates")

      assert html =~ "Rate updated successfully"
    end

    test "deletes rate in listing", %{conn: conn, rate: rate} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/currencies/#{rate.currency_id}/rates")

      assert index_live |> element("#rates-#{rate.id} a[id=#{rate.id}_delete]") |> render_click()
      refute has_element?(index_live, "#rate-#{rate.id}")
    end
  end

  describe "Show" do
    setup [:create_rate]

    test "displays rate", %{conn: conn, rate: rate} do
      {:ok, _show_live, html} = live(conn, ~p"/settings/currencies/#{rate.currency_id}/rates/#{rate}")

      assert html =~ "Show Rate"
    end

    test "updates rate within modal", %{conn: conn, rate: rate} do
      {:ok, show_live, _html} = live(conn, ~p"/settings/currencies/#{rate.currency_id}/rates/#{rate}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Rate"

      assert_patch(show_live, ~p"/settings/currencies/#{rate.currency_id}/rates/#{rate}/show/edit")

      invalid_attrs = %{ @invalid_attrs | currency_id: rate.currency_id }

      assert show_live
             |> form("#rate-form", rate: invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      update_attrs = %{ @update_attrs | currency_id: rate.currency_id }

      {:ok, _, html} =
        show_live
        |> form("#rate-form", rate: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/settings/currencies/#{rate.currency_id}/rates/#{rate}")

      assert html =~ "Rate updated successfully"
    end
  end
end
