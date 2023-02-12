defmodule InvoicerWeb.ProductLive.Show do
  use InvoicerWeb, :live_view

  alias Invoicer.Products
  alias Invoicer.Uoms
  alias Invoicer.Taxes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    product = Products.get_product!(id)
    uom = Uoms.get_uom!(product.uom_id)
    saletaxes = case product.saletaxes do
      [_ | _] -> product.saletaxes |> Enum.map(&Taxes.get_tax!/1)
      nil -> []
    end
    purchasetaxes = case product.purchasetaxes do
      [_ | _] -> product.purchasetaxes |> Enum.map(&Taxes.get_tax!/1)
      nil -> []
    end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, product)
     |> assign(:uom, uom)
     |> assign(:saletaxes, saletaxes)
     |> assign(:purchasetaxes, purchasetaxes)}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
