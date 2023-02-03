defmodule InvoicerWeb.BankAccountLive.FormComponent do
  use InvoicerWeb, :live_component

  alias Invoicer.Bank.Accounts
  alias Invoicer.Currencies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage bank account records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="bank-account-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :partner_id}} type="hidden" />
        <.input field={{f, :name}} type="text" label="Name" />
        <.input field={{f, :number}} type="text" label="Number" />
        <.input field={{f, :currency_id}} type="select" label="Currency" options={@currencies} />
        <:actions>
          <.button class="btn-sm" phx-disable-with="Saving...">Save Account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{account: account} = assigns, socket) do
    changeset = Accounts.change_account(account)

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
  def handle_event("validate", %{"account" => account_params}, socket) do
    changeset =
      socket.assigns.account
      |> Accounts.change_account(account_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"account" => account_params}, socket) do
    save_bank_account(socket, socket.assigns.action, account_params)
  end

  defp save_bank_account(socket, :edit_bank_account, account_params) do
    case Accounts.update_account(socket.assigns.account, account_params) do
      {:ok, _account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_bank_account(socket, :new_bank_account, account_params) do
    case Accounts.create_account(account_params) do
      {:ok, _address} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
