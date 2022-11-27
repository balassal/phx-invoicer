defmodule InvoicerWeb.UomLive.Show do
  use InvoicerWeb, :live_view

  alias Invoicer.Uoms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {InvoicerWeb.Layouts, :settings}}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:uom, Uoms.get_uom!(id))}
  end

  defp page_title(:show), do: "Show Uom"
  defp page_title(:edit), do: "Edit Uom"
end
