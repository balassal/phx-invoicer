defmodule InvoicerWeb.UomLive.Index do
  use InvoicerWeb, :live_view

  alias Invoicer.Uoms
  alias Invoicer.Uoms.Uom

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :uoms, list_uoms())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Uom")
    |> assign(:uom, Uoms.get_uom!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Uom")
    |> assign(:uom, %Uom{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Uoms")
    |> assign(:uom, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    uom = Uoms.get_uom!(id)
    {:ok, _} = Uoms.delete_uom(uom)

    {:noreply, assign(socket, :uoms, list_uoms())}
  end

  defp list_uoms do
    Uoms.list_uoms()
  end
end
