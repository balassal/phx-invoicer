defmodule Invoicer.Invoice.Lines do
  @moduledoc """
  The Invoice.Lines context.
  """

  import Ecto.Query, warn: false
  alias Invoicer.Repo

  alias Invoicer.Invoice.Lines.InvoiceLine

  @doc """
  Returns the list of invoice_lines.

  ## Examples

      iex> list_invoice_lines()
      [%InvoiceLine{}, ...]

  """
  def list_invoice_lines do
    Repo.all(InvoiceLine)
  end

  @doc """
  Gets a single invoice_line.

  Raises `Ecto.NoResultsError` if the Invoice line does not exist.

  ## Examples

      iex> get_invoice_line!(123)
      %InvoiceLine{}

      iex> get_invoice_line!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice_line!(id), do: Repo.get!(InvoiceLine, id)

  @doc """
  Creates a invoice_line.

  ## Examples

      iex> create_invoice_line(%{field: value})
      {:ok, %InvoiceLine{}}

      iex> create_invoice_line(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invoice_line(attrs \\ %{}) do
    %InvoiceLine{}
    |> InvoiceLine.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a invoice_line.

  ## Examples

      iex> update_invoice_line(invoice_line, %{field: new_value})
      {:ok, %InvoiceLine{}}

      iex> update_invoice_line(invoice_line, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice_line(%InvoiceLine{} = invoice_line, attrs) do
    invoice_line
    |> InvoiceLine.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a invoice_line.

  ## Examples

      iex> delete_invoice_line(invoice_line)
      {:ok, %InvoiceLine{}}

      iex> delete_invoice_line(invoice_line)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice_line(%InvoiceLine{} = invoice_line) do
    Repo.delete(invoice_line)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice_line changes.

  ## Examples

      iex> change_invoice_line(invoice_line)
      %Ecto.Changeset{data: %InvoiceLine{}}

  """
  def change_invoice_line(%InvoiceLine{} = invoice_line, attrs \\ %{}) do
    InvoiceLine.changeset(invoice_line, attrs)
  end
end
