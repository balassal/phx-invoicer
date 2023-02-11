defmodule InvoicerWeb.CompanyLive.Edit do
  use InvoicerWeb, :live_view
  alias Phoenix.LiveView.JS
  alias Invoicer.Repo
  alias Invoicer.{Addresses, Partners, Currencies, Bank.Accounts, Bank.Accounts.Account}
  alias Invoicer.Addresses.Address

  @impl true
  def mount(_params, _session, socket) do
    company = Partners.get_company() |> Repo.preload([:addresses, :bank_accounts])
    changeset = Partners.change_partner(company)

    {:ok,
     socket
     |> assign(:company, company)
     |> assign(:changeset, changeset)
     |> assign(:currencies, assign_currencies())}
  end

  defp assign_currencies() do
    Currencies.list_currencies()
    |> Enum.reduce([], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  @impl true
  def handle_event("validate", %{"partner" => company_params}, socket) do
    changeset =
      socket.assigns.company
      |> Partners.change_partner(company_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"partner" => company_params}, socket) do
    case Partners.update_partner(socket.assigns.company, company_params) do
      {:ok, _company} ->
        {:noreply,
          socket
          |> put_flash(:info, "Company updated successfully")
          |> push_navigate(to: "/settings/company")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("new_address", _, socket) do
    socket =
      socket
      |> assign(:page_title, "New Address")
      |> assign(:new_address, %Address{partner_id: socket.assigns.company.id})
      |> assign(:live_action, :new_address)
    {:noreply, socket}
  end

  @impl true
  def handle_event("edit_address", %{"address" => address_id}, socket) do
    address = Addresses.get_address!(address_id)
    socket =
      socket
      |> assign(:page_title, "Edit Address")
      |> assign(:edit_address, address)
      |> assign(:live_action, :edit_address)
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_address", %{"address" => address_id}, socket) do
    address = Addresses.get_address!(address_id)
    {:ok, _} = Addresses.delete_address(address)
    # JS.navigate("/settings/company/edit")
    # redirect(socket, to: "/settings/company/edit")
    {:noreply, push_patch(socket, to: "/settings/company/edit")}
  end

  @impl true
  def handle_event("new_bank_account", _, socket) do
    socket =
      socket
      |> assign(:page_title, "New Bank Account")
      |> assign(:new_bank_account, %Account{partner_id: socket.assigns.company.id})
      |> assign(:live_action, :new_bank_account)
    {:noreply, socket}
  end

  @impl true
  def handle_event("edit_bank_account", %{"bank-account" => account_id}, socket) do
    account = Accounts.get_account!(account_id)
    socket =
      socket
      |> assign(:page_title, "Edit Bank Account")
      |> assign(:edit_bank_account, account)
      |> assign(:live_action, :edit_bank_account)
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_bank_account", %{"bank-account" => account_id}, socket) do
    account = Accounts.get_account!(account_id)
    {:ok, _} = Accounts.delete_account(account)
    # JS.navigate("/settings/company/edit")
    # redirect(socket, to: "/settings/company/edit")
    {:noreply, push_patch(socket, to: "/settings/company/edit")}
  end
end
