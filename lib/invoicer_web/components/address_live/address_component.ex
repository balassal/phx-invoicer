defmodule InvoicerWeb.AddressLive.AddressComponent do
  use InvoicerWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="card w-96 bg-base-200 shadow-lg hover:shadow-xl">
      <div class="card-body">
        <div class="flex align-middle justify-between">
          <h2 class="card-title"><%= @address.street %></h2>
          <.address_icon type={@address.type} />
        </div>
        <p>
          <%= @address.zip %> <%= @address.city %>
        </p>
        <p>
          <%= @address.country %>
        </p>
        <div class="card-actions justify-end">
          <.button class="btn-warning btn-sm btn-circle" phx-click="edit_address" phx-value-address={@address.id}>
            <Heroicons.pencil solid class="h-5 w-5" />
          </.button>
          <.button class="btn-error btn-sm btn-circle" data-confirm="Are you sure?" phx-click="delete_address" phx-value-address={@address.id}>
            <Heroicons.trash solid class="h-5 w-5" />
          </.button>
        </div>
      </div>
    </div>
    """
  end


  attr :type, :string

  def address_icon(%{type: "main"} = assigns) do
    ~H"""
    <div class="tooltip tooltip-right" data-tip="Main Address">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 21v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21m0 0h4.5V3.545M12.75 21h7.5V10.75M2.25 21h1.5m18 0h-18M2.25 9l4.5-1.636M18.75 3l-1.5.545m0 6.205l3 1m1.5.5l-1.5-.5M6.75 7.364V3h-3v18m3-13.636l10.5-3.819" />
      </svg>
    </div>
    """
  end

  def address_icon(%{type: "invoice"} = assigns) do
    ~H"""
    <div class="tooltip tooltip-right" data-tip="Invoice Address">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 17.25v3.375c0 .621-.504 1.125-1.125 1.125h-9.75a1.125 1.125 0 01-1.125-1.125V7.875c0-.621.504-1.125 1.125-1.125H6.75a9.06 9.06 0 011.5.124m7.5 10.376h3.375c.621 0 1.125-.504 1.125-1.125V11.25c0-4.46-3.243-8.161-7.5-8.876a9.06 9.06 0 00-1.5-.124H9.375c-.621 0-1.125.504-1.125 1.125v3.5m7.5 10.375H9.375a1.125 1.125 0 01-1.125-1.125v-9.25m12 6.625v-1.875a3.375 3.375 0 00-3.375-3.375h-1.5a1.125 1.125 0 01-1.125-1.125v-1.5a3.375 3.375 0 00-3.375-3.375H9.75" />
      </svg>
    </div>
    """
  end

  def address_icon(%{type: "delivery"} = assigns) do
    ~H"""
    <div class="tooltip tooltip-right" data-tip="Delivery Address">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8">
        <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 01-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 00-3.213-9.193 2.056 2.056 0 00-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 00-10.026 0 1.106 1.106 0 00-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12" />
      </svg>
    </div>
    """
  end
end
