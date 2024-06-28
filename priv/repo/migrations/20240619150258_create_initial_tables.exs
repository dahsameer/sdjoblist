defmodule Sdjoblist.Repo.Migrations.CreateInitialTables do
  use Ecto.Migration

  def change do
    create table(:company) do
      add :name, :string
      add :description, :string
      add :website, :string
      add :process, :string
      add :last_run_time, :string
      add :last_run_status, :integer
      timestamps()
    end

    create table(:job) do
      add :company_id, references(:company, on_delete: :delete_all), null: false
      add :title, :string
      add :description, :string
      add :link, :string
      add :job_time, :string
      timestamps()
    end

    create table(:jobfetchlogs) do
      add :company_id, references(:company, on_delete: :delete_all), null: false
      add :run_time, :string
      add :run_status, :integer
      add :detail, :string
    end
  end
end
