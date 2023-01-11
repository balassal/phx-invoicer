defmodule InvoicerWeb.PartnerLive.FormComponent do
  use InvoicerWeb, :live_component

  alias Invoicer.Partners
  alias Invoicer.Currencies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage partner records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="partner-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :active}} type="checkbox" label="Active" />
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :vatnumber}} type="text" label="VAT Number" />
        <.input field={{f, :type}} type="select" label="Type" options={["customer", "supplier", "other"]} />
        <.input field={{f, :payment_method}} type="select" label="Payment Method" options={["transfer", "credit", "card", "cash", "voucher"]} />
        <.input field={{f, :payment_term}} type="number" label="Payment Therm" step="any" />
        <.input field={{f, :currency}} type="select" label="Currency" options={@currencies} />
        <:actions>
          <.button class="btn-sm" phx-disable-with="Saving...">Save Partner</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{partner: partner} = assigns, socket) do
    changeset = Partners.change_partner(partner)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:currencies, assign_currencies())}
  end

  defp assign_currencies() do
    Currencies.list_currencies()
    |> Enum.reduce([], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  @impl true
  def handle_event("validate", %{"partner" => partner_params}, socket) do
    changeset =
      socket.assigns.partner
      |> Partners.change_partner(partner_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"partner" => partner_params}, socket) do
    save_partner(socket, socket.assigns.action, partner_params)
  end

  defp save_partner(socket, :edit, partner_params) do
    case Partners.update_partner(socket.assigns.partner, partner_params) do
      {:ok, _partner} ->
        {:noreply,
         socket
         |> put_flash(:info, "Partner updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_partner(socket, :new, partner_params) do
    case Partners.create_partner(partner_params) do
      {:ok, _partner} ->
        {:noreply,
         socket
         |> put_flash(:info, "Partner created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
