defmodule InvoicerWeb.BankAccountLive.BankAccountComponent do
  use InvoicerWeb, :live_component

  alias Invoicer.Currencies

  @impl true
  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(:account, assigns.account)
      |> assign(:currency, Currencies.get_currency!(assigns.account.currency_id))}
  end

  # def handle_info({:get_currency, socker}, socket) do
  #   # socket = assign(socket, key: value)
  #   {:noreply, socket}
  # end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="card w-96 bg-base-200 shadow-lg hover:shadow-xl">
      <div class="card-body">
        <h2 class="card-title flex justify-between">
          <span>
            <%= @account.name %>
          </span>
          <span>
            <%= @currency.symbol %>
          </span>
        </h2>
        <%= @account.number %>
        <div class="card-actions justify-end">
          <.button class="btn-warning btn-sm btn-circle" phx-click="edit_bank_account" phx-value-bank-account={@account.id}>
            <Heroicons.pencil solid class="h-5 w-5" />
          </.button>
          <.button class="btn-error btn-sm btn-circle" data-confirm="Are you sure?" phx-click="delete_bank_account" phx-value-bank-account={@account.id}>
            <Heroicons.trash solid class="h-5 w-5" />
          </.button>
        </div>
      </div>
    </div>
    """
  end
end
