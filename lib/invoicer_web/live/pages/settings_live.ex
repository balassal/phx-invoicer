defmodule InvoicerWeb.Pages.SettingsLive do
  use InvoicerWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {InvoicerWeb.Layouts, :settings}}
  end
end
