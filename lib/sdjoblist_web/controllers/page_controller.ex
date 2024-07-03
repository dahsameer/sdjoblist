defmodule SdjoblistWeb.PageController do
  alias Sdjoblist.Companies
  alias Sdjoblist.Jobs
  use SdjoblistWeb, :controller

  def home(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, :home, jobs: jobs)
  end

  def status(conn, _params) do
    companies = Companies.list_companies()
    render(conn, :status, companies: companies)
  end

  def contact(conn, _params) do
    render(conn, :contact)
  end
end
