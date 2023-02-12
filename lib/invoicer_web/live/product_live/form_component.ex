defmodule InvoicerWeb.ProductLive.FormComponent do
  use InvoicerWeb, :live_component

  alias Invoicer.Products
  alias Invoicer.Uoms
  alias Invoicer.Taxes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :active}} type="checkbox" label="Active" />
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :label}} type="text" label="Label" />
        <.input field={{f, :reference}} type="text" label="Reference" placeholder="ABC123" />
        <.input field={{f, :type}} type="select" label="Type" options={["product", "service", "other"]} />
        <.input field={{f, :unitprice}} type="number" label="Unit Price" step="any" />
        <.input field={{f, :uom_id}} type="select" label="Unit of Measure" options={@uoms} />
        <.input field={{f, :saletaxes}} type="select" multiple label="Sale Taxes" options={@taxes} />
        <.input field={{f, :purchasetaxes}} type="select" multiple label="Purchase Taxes" options={@taxes} />
        <.input field={{f, :note}} type="textarea" label="Note" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:uoms, assign_uoms())
     |> assign(:taxes, assign_taxes())}
  end

  defp assign_uoms do
    Uoms.list_uoms()
    |> Enum.reduce([], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  defp assign_taxes do
    Taxes.list_taxes()
    |> Enum.reduce([], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Products.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Products.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Products.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
