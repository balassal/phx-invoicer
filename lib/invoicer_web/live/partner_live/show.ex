defmodule InvoicerWeb.PartnerLive.Show do
  use InvoicerWeb, :live_view
  alias Invoicer.Repo
  alias Invoicer.Partners
  alias Invoicer.Addresses
  alias Invoicer.Addresses.Address
  alias Phoenix.LiveView.JS
  alias Invoicer.Currencies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    partner = Partners.get_partner!(id) |> Repo.preload([:addresses])
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:partner, partner)
     |> assign(:currency, Currencies.get_currency!(partner.currency_id))}
  end

  defp page_title(:show), do: "Show Partner"
  defp page_title(:edit), do: "Edit Partner"

  @impl true
  def handle_event("edit_address", %{"address" => address_id}, socket) do
    address = Addresses.get_address!(address_id)
    socket =
      socket
      |> assign(:page_title, "Edit Address")
      |> assign(:edit_address, address)
      |> assign(:live_action, :edit_address)
    {:noreply, socket}
  end

  @impl true
  def handle_event("new_address", _, socket) do
    socket =
      socket
      |> assign(:page_title, "Edit Address")
      |> assign(:new_address, %Address{partner_id: socket.assigns.partner.id})
      |> assign(:live_action, :new_address)
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_address", %{"address" => address_id}, socket) do
    address = Addresses.get_address!(address_id)
    {:ok, _} = Addresses.delete_address(address)
    JS.patch("/partners/#{socket.assigns.partner}")
    {:noreply, socket}
  end
end
