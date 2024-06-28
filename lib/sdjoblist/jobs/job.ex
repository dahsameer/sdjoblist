defmodule Sdjoblist.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job" do
    field :company_id, :integer
    field :title, :string
    field :description, :string
    field :link, :string
    field :job_time, :string
    timestamps()
  end

  def changeset(job, attrs) do
    job
    |> cast(attrs, [:company_id, :title, :description, :link, :job_time])
    |> validate_required([:title, :link])
  end

end
