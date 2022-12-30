defmodule InvoicerWeb.PartnerLiveTest do
  use InvoicerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Invoicer.PartnersFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_partner(_) do
    partner = partner_fixture()
    %{partner: partner}
  end

  describe "Index" do
    setup [:create_partner]

    test "lists all partners", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/partners")

      assert html =~ "Listing Partners"
    end

    test "saves new partner", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/partners")

      assert index_live |> element("a", "New Partner") |> render_click() =~
               "New Partner"

      assert_patch(index_live, ~p"/partners/new")

      assert index_live
             |> form("#partner-form", partner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#partner-form", partner: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/partners")

      assert html =~ "Partner created successfully"
    end

    test "updates partner in listing", %{conn: conn, partner: partner} do
      {:ok, index_live, _html} = live(conn, ~p"/partners")

      assert index_live |> element("#partners-#{partner.id} a", "Edit") |> render_click() =~
               "Edit Partner"

      assert_patch(index_live, ~p"/partners/#{partner}/edit")

      assert index_live
             |> form("#partner-form", partner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#partner-form", partner: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/partners")

      assert html =~ "Partner updated successfully"
    end

    test "deletes partner in listing", %{conn: conn, partner: partner} do
      {:ok, index_live, _html} = live(conn, ~p"/partners")

      assert index_live |> element("#partners-#{partner.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#partner-#{partner.id}")
    end
  end

  describe "Show" do
    setup [:create_partner]

    test "displays partner", %{conn: conn, partner: partner} do
      {:ok, _show_live, html} = live(conn, ~p"/partners/#{partner}")

      assert html =~ "Show Partner"
    end

    test "updates partner within modal", %{conn: conn, partner: partner} do
      {:ok, show_live, _html} = live(conn, ~p"/partners/#{partner}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Partner"

      assert_patch(show_live, ~p"/partners/#{partner}/show/edit")

      assert show_live
             |> form("#partner-form", partner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#partner-form", partner: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/partners/#{partner}")

      assert html =~ "Partner updated successfully"
    end
  end
end
