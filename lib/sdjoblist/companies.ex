defmodule Sdjoblist.Companies do

  import Ecto.Query, warn: false
  alias Sdjoblist.Repo

  alias Sdjoblist.Jobs.Company

  def list_companies do
    from(c in Company, order_by: c.name)
      |> Repo.all()
  end

  def get_company(id) do
    Repo.get(Company, id)
  end

  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end
end
