defmodule Sdjoblist.Jobs.Job do
  alias Sdjoblist.Jobs.Company
  use Ecto.Schema
  import Ecto.Changeset

  schema "job" do
    field :title, :string
    field :description, :string
    field :link, :string
    field :job_time, :string
    belongs_to :company, Company
    timestamps()
  end

  def changeset(job, attrs) do
    job
    |> cast(attrs, [:company_id, :title, :description, :link, :job_time])
    |> validate_required([:title, :link])
  end

end
