defmodule InvoicerWeb.PartnerLive.Show do
  use InvoicerWeb, :live_view

  alias Invoicer.Partners
  alias Invoicer.Currencies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    partner = Partners.get_partner!(id)
    IO.inspect(partner)
    currency = Currencies.get_currency!(partner.currency_id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:partner, partner)
     |> assign(:currency, currency)}
  end

  defp page_title(:show), do: "Show Partner"
  defp page_title(:edit), do: "Edit Partner"
end
