defmodule Sdjoblist.Jobs do

  import Ecto.Query, warn: false
  alias Sdjoblist.Repo

  alias Sdjoblist.Jobs.Job

  def list_jobs do
    Repo.all(Job)
  end

  def get_job(id), do: Repo.get(Job, id)

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
