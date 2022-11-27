defmodule InvoicerWeb.UomLive.FormComponent do
  use InvoicerWeb, :live_component

  alias Invoicer.Uoms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <p class="mb-4">Adding new unit of measure</p>
      <.simple_form
        :let={f}
        for={@changeset}
        id="uom-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :label}} type="text" label="Label" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Uom</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{uom: uom} = assigns, socket) do
    changeset = Uoms.change_uom(uom)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"uom" => uom_params}, socket) do
    changeset =
      socket.assigns.uom
      |> Uoms.change_uom(uom_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"uom" => uom_params}, socket) do
    save_uom(socket, socket.assigns.action, uom_params)
  end

  defp save_uom(socket, :edit, uom_params) do
    case Uoms.update_uom(socket.assigns.uom, uom_params) do
      {:ok, _uom} ->
        {:noreply,
         socket
         |> put_flash(:info, "Uom updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_uom(socket, :new, uom_params) do
    case Uoms.create_uom(uom_params) do
      {:ok, _uom} ->
        {:noreply,
         socket
         |> put_flash(:info, "Uom created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
