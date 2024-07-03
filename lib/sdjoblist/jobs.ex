defmodule Sdjoblist.Jobs do

  import Ecto.Query, warn: false
  alias Sdjoblist.Jobs.Company
  alias Sdjoblist.Repo

  alias Sdjoblist.Jobs.Job

  def list_jobs do
    query = from(j in Job, join: c in Company, on: j.company_id == c.id, select: {j,c})
    Repo.all(query)
  end

  def get_job(id), do: Repo.get(Job, id)

  def get_company_jobs(id) do
    query = from(j in Job, where: j.company_id == ^id)
    Repo.all(query)
  end

  def create_job(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end

  def update_job(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  def change_job(%Job{} = job, attrs \\ %{}) do
    Job.changeset(job, attrs)
  end
end
