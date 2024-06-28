defmodule Sdjoblist.Companies do

  import Ecto.Query, warn: false
  alias Sdjoblist.Repo

  alias Sdjoblist.Jobs.Company

  def list_companies do
    Repo.all(Company)
  end

  def get_company(id) do
    Repo.get(Company, id)
  end

  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end
end
