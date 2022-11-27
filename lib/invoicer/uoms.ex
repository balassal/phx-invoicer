defmodule Invoicer.Uoms do
  @moduledoc """
  The Uoms context.
  """

  import Ecto.Query, warn: false
  alias Invoicer.Repo

  alias Invoicer.Uoms.Uom

  @doc """
  Returns the list of uoms.

  ## Examples

      iex> list_uoms()
      [%Uom{}, ...]

  """
  def list_uoms do
    Repo.all(Uom)
  end

  @doc """
  Gets a single uom.

  Raises `Ecto.NoResultsError` if the Uom does not exist.

  ## Examples

      iex> get_uom!(123)
      %Uom{}

      iex> get_uom!(456)
      ** (Ecto.NoResultsError)

  """
  def get_uom!(id), do: Repo.get!(Uom, id)

  @doc """
  Creates a uom.

  ## Examples

      iex> create_uom(%{field: value})
      {:ok, %Uom{}}

      iex> create_uom(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_uom(attrs \\ %{}) do
    %Uom{}
    |> Uom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a uom.

  ## Examples

      iex> update_uom(uom, %{field: new_value})
      {:ok, %Uom{}}

      iex> update_uom(uom, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_uom(%Uom{} = uom, attrs) do
    uom
    |> Uom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a uom.

  ## Examples

      iex> delete_uom(uom)
      {:ok, %Uom{}}

      iex> delete_uom(uom)
      {:error, %Ecto.Changeset{}}

  """
  def delete_uom(%Uom{} = uom) do
    Repo.delete(uom)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking uom changes.

  ## Examples

      iex> change_uom(uom)
      %Ecto.Changeset{data: %Uom{}}

  """
  def change_uom(%Uom{} = uom, attrs \\ %{}) do
    Uom.changeset(uom, attrs)
  end
end
