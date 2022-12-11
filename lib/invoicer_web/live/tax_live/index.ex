defmodule InvoicerWeb.TaxLive.Index do
  use InvoicerWeb, :live_view

  alias Invoicer.Taxes
  alias Invoicer.Taxes.Tax

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :taxes, list_taxes()), layout: {InvoicerWeb.Layouts, :settings}}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tax")
    |> assign(:tax, Taxes.get_tax!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tax")
    |> assign(:tax, %Tax{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Taxes")
    |> assign(:tax, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tax = Taxes.get_tax!(id)
    {:ok, _} = Taxes.delete_tax(tax)

    {:noreply, assign(socket, :taxes, list_taxes())}
  end

  defp list_taxes do
    Taxes.list_taxes()
  end
end
