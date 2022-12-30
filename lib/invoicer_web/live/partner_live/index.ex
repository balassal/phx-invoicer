defmodule InvoicerWeb.PartnerLive.Index do
  use InvoicerWeb, :live_view

  alias Invoicer.Partners
  alias Invoicer.Partners.Partner

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :partners, list_partners())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Partner")
    |> assign(:partner, Partners.get_partner!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Partner")
    |> assign(:partner, %Partner{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Partners")
    |> assign(:partner, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    partner = Partners.get_partner!(id)
    {:ok, _} = Partners.delete_partner(partner)

    {:noreply, assign(socket, :partners, list_partners())}
  end

  defp list_partners do
    Partners.list_partners()
  end
end
