defmodule InvoicerWeb.TaxLive.Show do
  use InvoicerWeb, :live_view

  alias Invoicer.Taxes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {InvoicerWeb.Layouts, :settings}}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tax, Taxes.get_tax!(id))}
  end

  defp page_title(:show), do: "Show Tax"
  defp page_title(:edit), do: "Edit Tax"
end
