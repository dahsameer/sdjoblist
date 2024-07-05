defmodule SdjoblistWeb.PageController do
  alias Sdjoblist.Companies
  alias Sdjoblist.Jobs
  use SdjoblistWeb, :controller

  def home(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, :home, jobs: jobs)
  end

  def scroll(conn, %{"page" => page}) do
    page = String.to_integer(page || "0")
    jobs = Jobs.list_jobs(page)
    render(conn, :scroll, jobs: jobs, root_layout: false, layout: false)
  end

  def status(conn, _params) do
    companies = Companies.list_companies()
    render(conn, :status, companies: companies)
  end

  def contact(conn, _params) do
    render(conn, :contact)
  end
end
