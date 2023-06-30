defmodule InvoicerWeb.InvoiceLive.Edit do
  use InvoicerWeb, :live_view

  alias Invoicer.Repo
  alias Invoicer.Invoice.Invoices
  alias Invoicer.Invoice.Invoices.Invoice
  alias Invoicer.Invoice.Lines
  alias Invoicer.Invoice.Lines.InvoiceLine
  alias Invoicer.Partners
  alias Invoicer.Currencies
  alias Invoicer.Uoms
  alias Invoicer.Products
  alias Invoicer.Taxes

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:partners, assign_partners())
     |> assign(:currencies, assign_currencies())
     |> assign(:uoms, assign_uoms())
     |> assign(:products, assign_products())
     |> assign(:bank_accounts, [])
     |> assign(:taxes, assign_taxes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    today = Date.utc_today()
    invoice_attrs = %{
      name: "Draft",
      date: today,
      delivery_date: today,
      due_date: today,
      notes: "",
      state: "new",
      payment_term: 0,
      invoice_lines: []
    }
    invoice = %Invoice{} |> Repo.preload(:invoice_lines)
    changeset =
      invoice
      |> Invoices.change_invoice(invoice_attrs)
      |> Ecto.Changeset.put_assoc(:invoice_lines, invoice_attrs.invoice_lines)

    socket
    |> assign(:page_title, "New Invoice")
    |> assign(:invoice, invoice)
    |> assign(:changeset, changeset)
  end

  @impl true
  def handle_event(
      "validate",
      %{"_target" => ["invoice", "partner_id"], "invoice" => %{"partner_id" => partner_id}} = invoice_params,
      socket) when partner_id != "" do
    partner = Partners.get_partner!(partner_id) |> Repo.preload([:bank_accounts])
    invoice_params =
      invoice_params["invoice"]
        |> Map.put("payment_method", partner.payment_method)
        |> Map.put("payment_term", partner.payment_term)
        |> Map.put("currency_id", partner.currency_id)
        |> Map.put("due_date", Date.add(Date.from_iso8601!(invoice_params["invoice"]["date"]), partner.payment_term))
        |> Map.put("exchange_rate", exchange_rate(partner.currency_id) |> Decimal.to_float())

    changeset =
      socket.assigns.invoice
      |> Invoices.change_invoice(invoice_params)
      |> Ecto.Changeset.put_assoc(:invoice_lines, invoice_params["invoice_lines"])
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(:partner, partner)
      |> assign(:changeset, changeset)
      |> assign(:bank_accounts, bank_accounts(partner.bank_accounts))

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"_target" => ["invoice", "partner_id"], "invoice" => invoice_params}, socket) do
    invoice_params = %{invoice_params | "partner_id" => ""}
    changeset =
      socket.assigns.invoice
      |> Invoices.change_invoice(invoice_params)
      |> Ecto.Changeset.put_assoc(:invoice_lines, invoice_params["invoice_lines"])
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(:partner, nil)
      |> assign(:bank_accounts, [])
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"_target" => ["invoice", "date"], "invoice" => invoice_params}, socket) do
    %{"date" => date, "payment_term" => payment_term} = invoice_params
    invoice_params =
      invoice_params
      |> Map.put("due_date", Date.add(Date.from_iso8601!(date), String.to_integer(payment_term)))
      |> Map.put("date", Date.from_iso8601!(date))

    changeset =
      socket.assigns.invoice
      |> Invoices.change_invoice(invoice_params)
      |> Ecto.Changeset.put_assoc(:invoice_lines, invoice_params["invoice_lines"])
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"_target" => ["invoice", "payment_term"], "invoice" => invoice_params}, socket) do
    %{"payment_term" => payment_term, "date" => date} = invoice_params
    invoice_params =
      invoice_params
      |> Map.put("due_date", Date.add(Date.from_iso8601!(date), String.to_integer(payment_term)))

      changeset =
      socket.assigns.invoice
      |> Invoices.change_invoice(invoice_params)
      |> Ecto.Changeset.put_assoc(:invoice_lines, invoice_params["invoice_lines"])
      |> Map.put(:action, :validate)


    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"_target" => ["invoice", "currency_id"], "invoice" => invoice_params}, socket) do
    %{"currency_id" => currency_id} = invoice_params
    rate = exchange_rate(currency_id)
    invoice_params =
      invoice_params
      |> Map.put("exchange_rate", Decimal.to_float(rate))
    changeset =
      socket.assigns.invoice
      |> Invoices.change_invoice(invoice_params)
      |> Ecto.Changeset.put_assoc(:invoice_lines, invoice_params["invoice_lines"])
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event(
    "validate",
    %{
      "_target" => ["invoice", "invoice_lines", line_index, "product_id"],
      "invoice" => invoice_params
    },
    socket
  ) do
    line = invoice_params["invoice_lines"][line_index]
    product = Products.get_product!(line["product_id"])
    line =
      line
      |> Map.put("label", product.label)
      |> Map.put("uom_id", product.uom_id)
      |> Map.put("unit_price", product.unitprice)
    invoice_lines =
      invoice_params["invoice_lines"]
      |> Map.put(line_index, line)
    # invoice_params =
    #   invoice_params
    #   |> Map.put("invoice_lines", invoice_lines)

    # changeset =
    #   socket.assigns.invoice
    #   |> Invoices.change_invoice(invoice_params)
    #   |> Map.put(:action, :validate)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:invoice_lines, invoice_lines)
    IO.inspect(socket.assigns.changeset, label: "changeset >>")

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event(
    "validate",
    %{
      "_target" => ["invoice", "invoice_lines", line_index, _field],
      "invoice" => invoice_params
    },
    socket
  ) do
    IO.inspect(socket.assigns, label: " >>> socket.assigns")
    line = invoice_params["invoice_lines"][line_index]
    line = calculate_line(line)

    # invoice_lines =
    #   invoice_params["invoice_lines"]
    #   |> Map.put(line_index, line)
    # invoice_params =
    #   invoice_params
    #   |> Map.put("invoice_lines", invoice_lines)

    # changeset =
    #   socket.assigns.invoice
    #   |> Invoices.change_invoice(invoice_params)
    #   |> Map.put(:action, :validate)

    # {:noreply, assign(socket, changeset: changeset)}
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"invoice" => invoice_params}, socket) do
    changeset =
      socket.assigns.invoice
      |> Invoices.change_invoice(invoice_params)
      |> Ecto.Changeset.put_assoc(:invoice_lines, invoice_params["invoice_lines"])
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("add-line", _, socket) do
    existing_lines = Map.get(
      socket.assigns.changeset.changes, :invoice_lines, socket.assigns.invoice.invoice_lines
    )
    lines =
      existing_lines
      |> Enum.concat([
        Lines.change_invoice_line(%InvoiceLine{temp_id: get_temp_id()})
      ])
    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:invoice_lines, lines)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("remove-line", %{"index" => remove_id} = params, socket) do
    IO.inspect(params, label: ">>> params")
    invoice_lines =
      socket.assigns.changeset.changes.invoice_lines
      |> Enum.reject(fn %{data: line} ->
        line.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:invoice_lines, invoice_lines)

    {:noreply, assign(socket, changeset: changeset)}
  end

  ############### Private Functions ###############

  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)

  defp exchange_rate(currency_id) do
    currency = Currencies.get_currency!(currency_id) |> Repo.preload(:rates)
    sorted_rates = Enum.sort_by(currency.rates, &(&1.date), {:desc, Date})
    last_rate = Enum.at(sorted_rates, 0)
    last_rate.exchange
  end

  defp assign_partners do
    Partners.list_partners()
    |> Enum.reduce(["": ""], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  defp assign_currencies do
    Currencies.list_currencies()
    |> Enum.reduce([], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  defp assign_uoms do
    Uoms.list_uoms()
    |> Enum.reduce(["": ""], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  defp assign_products do
    Products.list_products()
    |> Enum.reduce(["": ""], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  defp bank_accounts(accounts) do
    accounts
    |> Enum.reduce([], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  defp assign_taxes do
    Taxes.list_taxes()
    |> Enum.reduce([], fn curr, acc -> acc ++ ["#{curr.name}": curr.id] end)
  end

  defp calculate_line(line) do
    {q, _} = Float.parse(line["quantity"])
    {up, _} = Float.parse(line["unit_price"])
    line = Map.put(line, "amount", Float.floor(q * up, 2))
    line = Map.put(line, "tax_amount", calc_tax(line))
    line = Map.put(line, "total", line["amount"] + line["tax_amount"])

    line
  end

  defp calc_tax(%{"tax_ids" => tax_ids} = line) do
    tax_amount = Enum.reduce(tax_ids, 0, fn x, acc ->
      tax = Taxes.get_tax!(x)
      acc + (Decimal.to_float(tax.amount) * line["amount"])
    end)
    Float.floor(tax_amount,2)
  end

  defp calc_tax(_) do
    0
  end

end
