defmodule InvoicerWeb.RateLive.FormComponent do
  use InvoicerWeb, :live_component

  alias Invoicer.Rates

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage rate records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="rate-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :date}} type="datetime-local" label="date" />
        <.input field={{f, :exchange}} type="number" label="exchange" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Rate</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{rate: rate} = assigns, socket) do
    changeset = Rates.change_rate(rate)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"rate" => rate_params}, socket) do
    changeset =
      socket.assigns.rate
      |> Rates.change_rate(rate_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"rate" => rate_params}, socket) do
    save_rate(socket, socket.assigns.action, rate_params)
  end

  defp save_rate(socket, :edit, rate_params) do
    case Rates.update_rate(socket.assigns.rate, rate_params) do
      {:ok, _rate} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rate updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_rate(socket, :new, rate_params) do
    case Rates.create_rate(rate_params) do
      {:ok, _rate} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rate created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
