defmodule InvoicerWeb.CompanyLive.Index do
  use InvoicerWeb, :live_view
  import InvoicerWeb.AddressLive.AddressComponent

  alias Invoicer.Partners
  alias Invoicer.Currencies
  alias Invoicer.Repo

  @impl true
  def mount(_params, _session, socket) do
    company = assign_company()
    currency = assign_currency(company)
    {:ok,
     socket
     |> assign(:company, company)
     |> assign(:currency, currency),
     layout: {InvoicerWeb.Layouts, :settings}}
  end

  defp assign_company do
    Partners.get_company() |> Repo.preload([:addresses, :bank_accounts])
  end

  defp assign_currency(partner) do
    Currencies.get_currency!(partner.currency_id)
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action)}
  end

  defp apply_action(socket, :index) do
    socket
    |> assign(:page_title, "Company")
  end

  defp apply_action(socket, :edit) do
    socket
    |> assign(:page_title, "Edit Company")
  end
end
