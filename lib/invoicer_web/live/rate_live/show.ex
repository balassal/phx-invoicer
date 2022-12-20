defmodule InvoicerWeb.RateLive.Show do
  use InvoicerWeb, :live_view

  alias Invoicer.Rates
  alias Invoicer.Currencies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {InvoicerWeb.Layouts, :settings}}
  end

  @impl true
  def handle_params(%{"id" => currency_id, "rate_id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:rate, assign_rate(id))
     |> assign(:currency, assign_currency(currency_id))}
  end

  defp assign_rate(id) do
    Rates.get_rate!(id)
  end

  defp assign_currency(id) do
    Currencies.get_currency!(id)
  end

  defp page_title(:show), do: "Show Rate"
  defp page_title(:edit), do: "Edit Rate"
end
