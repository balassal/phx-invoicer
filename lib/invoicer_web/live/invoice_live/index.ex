defmodule InvoicerWeb.InvoiceLive.Index do
  use InvoicerWeb, :live_view

  alias Invoicer.Invoice.Invoices

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :invoices, list_invoices())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Invoices")
    |> assign(:invoice, nil)
  end

  defp list_invoices do
    Invoices.list_invoices()
  end
end
