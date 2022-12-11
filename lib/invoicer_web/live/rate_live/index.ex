defmodule InvoicerWeb.RateLive.Index do
  use InvoicerWeb, :live_view

  alias Invoicer.Rates
  alias Invoicer.Rates.Rate

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :rates, list_rates()), layout: {InvoicerWeb.Layouts, :settings}}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Rate")
    |> assign(:rate, Rates.get_rate!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Rate")
    |> assign(:rate, %Rate{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rates")
    |> assign(:rate, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rate = Rates.get_rate!(id)
    {:ok, _} = Rates.delete_rate(rate)

    {:noreply, assign(socket, :rates, list_rates())}
  end

  defp list_rates do
    Rates.list_rates()
  end
end
