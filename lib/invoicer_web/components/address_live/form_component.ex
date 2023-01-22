defmodule InvoicerWeb.AddressLive.FormComponent do
  use InvoicerWeb, :live_component

  alias Invoicer.Addresses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage address records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="address-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :partner_id}} type="hidden" />
        <.input field={{f, :active}} type="checkbox" label="Active" />
        <.input field={{f, :type}} type="select" label="Type" options={["main", "invoice", "delivery"]} />
        <.input field={{f, :street}} type="text" label="Street" />
        <.input field={{f, :city}} type="text" label="City" />
        <.input field={{f, :country}} type="text" label="Country" />
        <.input field={{f, :zip}} type="text" label="ZIP" />
        <:actions>
          <.button class="btn-sm" phx-disable-with="Saving...">Save Address</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{address: address} = assigns, socket) do
    changeset = Addresses.change_address(address)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"address" => address_params}, socket) do
    changeset =
      socket.assigns.address
      |> Addresses.change_address(address_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"address" => address_params}, socket) do
    save_address(socket, socket.assigns.action, address_params)
  end

  defp save_address(socket, :edit_address, address_params) do
    case Addresses.update_address(socket.assigns.address, address_params) do
      {:ok, _address} ->
        {:noreply,
         socket
         |> put_flash(:info, "Address updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_address(socket, :new_address, address_params) do
    # address_params = Map.put(address_params, "partner_id", socket.assigns.address.partner_id)
    case Addresses.create_address(address_params) do
      {:ok, _address} ->
        {:noreply,
         socket
         |> put_flash(:info, "Address created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
