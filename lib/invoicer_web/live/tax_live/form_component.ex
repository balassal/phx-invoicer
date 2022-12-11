defmodule InvoicerWeb.TaxLive.FormComponent do
  use InvoicerWeb, :live_component

  alias Invoicer.Taxes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tax records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="tax-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :active}} type="checkbox" label="Active" />
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :category}} type="text" label="Category" />
        <.input field={{f, :type}} type="select" label="Type" options={["sale", "purchase", "both", "other"]} />
        <.input field={{f, :scope}} type="select" label="Scope" options={["item", "invoice"]} />
        <.input field={{f, :computation}} type="select" label="Computation" options={["percentage", "value"]} />
        <.input field={{f, :amount}} type="number" label="Amount" step="any" />
        <.input field={{f, :included}} type="checkbox" label="Included" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tax</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tax: tax} = assigns, socket) do
    changeset = Taxes.change_tax(tax)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"tax" => tax_params}, socket) do
    changeset =
      socket.assigns.tax
      |> Taxes.change_tax(tax_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tax" => tax_params}, socket) do
    save_tax(socket, socket.assigns.action, tax_params)
  end

  defp save_tax(socket, :edit, tax_params) do
    case Taxes.update_tax(socket.assigns.tax, tax_params) do
      {:ok, _tax} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tax updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_tax(socket, :new, tax_params) do
    case Taxes.create_tax(tax_params) do
      {:ok, _tax} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tax created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
