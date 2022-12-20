defmodule InvoicerWeb.RateLive.Index do
  use InvoicerWeb, :live_view

  alias Invoicer.Rates
  alias Invoicer.Currencies
  alias Invoicer.Rates.Rate

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket =
      socket
      |> assign(:rates, list_rates(id))
      |> assign(:currency, assign_currency(id))

    {:ok, socket, layout: {InvoicerWeb.Layouts, :settings}}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"rate_id" => id}) do
    socket
    |> assign(:page_title, "Edit Rate")
    |> assign(:rate, Rates.get_rate!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Rate")
    |> assign(:rate, %Rate{currency_id: socket.assigns.currency.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rates")
    |> assign(:rate, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id, "currency_id" => currency_id}, socket) do
    rate = Rates.get_rate!(id)
    {:ok, _} = Rates.delete_rate(rate)

    {:noreply, assign(socket, :rates, list_rates(currency_id))}
  end

  defp list_rates(currency_id) do
    Rates.get_rates_by_currency(currency_id)
  end

  defp assign_currency(currency_id) do
    Currencies.get_currency!(currency_id)
  end
end
