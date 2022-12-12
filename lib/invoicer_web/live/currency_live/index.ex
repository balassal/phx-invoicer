defmodule InvoicerWeb.CurrencyLive.Index do
  use InvoicerWeb, :live_view

  alias Invoicer.Currencies
  alias Invoicer.Currencies.Currency

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :currencies, list_currencies()), layout: {InvoicerWeb.Layouts, :settings}}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Currency")
    |> assign(:currency, Currencies.get_currency!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Currency")
    |> assign(:currency, %Currency{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Currencies")
    |> assign(:currency, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    currency = Currencies.get_currency!(id)
    {:ok, _} = Currencies.delete_currency(currency)

    {:noreply, assign(socket, :currencies, list_currencies())}
  end

  defp list_currencies do
    Currencies.list_currencies()
  end
end
