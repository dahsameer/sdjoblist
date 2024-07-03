defmodule Sdjoblist.Jobs.Company do
  alias Sdjoblist.Jobs.Job
  use Ecto.Schema
  import Ecto.Changeset


  schema "company" do
    field :name, :string
    field :description, :string
    field :image, :string
    field :website, :string
    field :process, :string
    field :last_run_time, :string
    field :last_run_status, :integer
    has_many :jobs, Job
    timestamps()
  end

  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :description, :website, :process, :last_run_time, :last_run_status])
    |> validate_required([:name, :process, :last_run_time, :last_run_status])
  end
end
