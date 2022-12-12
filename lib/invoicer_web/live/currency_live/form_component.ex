defmodule InvoicerWeb.CurrencyLive.FormComponent do
  use InvoicerWeb, :live_component

  alias Invoicer.Currencies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage currency records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="currency-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :label}} type="text" label="Label" />
        <.input field={{f, :symbol}} type="text" label="Symbol" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Currency</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{currency: currency} = assigns, socket) do
    changeset = Currencies.change_currency(currency)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"currency" => currency_params}, socket) do
    changeset =
      socket.assigns.currency
      |> Currencies.change_currency(currency_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"currency" => currency_params}, socket) do
    save_currency(socket, socket.assigns.action, currency_params)
  end

  defp save_currency(socket, :edit, currency_params) do
    case Currencies.update_currency(socket.assigns.currency, currency_params) do
      {:ok, _currency} ->
        {:noreply,
         socket
         |> put_flash(:info, "Currency updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_currency(socket, :new, currency_params) do
    case Currencies.create_currency(currency_params) do
      {:ok, _currency} ->
        {:noreply,
         socket
         |> put_flash(:info, "Currency created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
