defmodule SdjoblistWorker.Fetcher do
  require Logger
  alias Sdjoblist.Jobs
  alias Sdjoblist.Companies

  def process() do
    companies = Companies.list_companies()

    for company <- companies do
      spawn(fn -> processcompany(company) end)
    end
  end

  def processcompany(company) do
    try do
      {res, process} = Jason.decode(company.process)

      if res == :error do
        raise "error while parsing process json for companyid: " <> company.id
      end

      res =
        case process["fetch_type"] do
          "api" -> fetch_api(process, company)
          "scrape" -> fetch_scrape(process, company)
        end

      existingjobs = Jobs.get_company_jobs(company.id)

      Enum.map(existingjobs, fn j ->
        exists = Enum.find(res, fn r -> j.title == r.title end)

        case exists do
          nil -> Jobs.delete_job(j)
          _ -> Jobs.update_job(j, exists)
        end
      end)

      Enum.map(res, fn r ->
        exists = Enum.find(existingjobs, fn j -> j.title == r.title end)

        if exists == nil do
          Jobs.create_job(r)
        end
      end)

      Companies.update_company(company, %{
        last_run_time: DateTime.to_string(DateTime.utc_now()),
        last_run_status: 1
      })
    rescue
      e in RuntimeError ->
        Logger.error("error while running fetch job: " <> e.message)

        Companies.update_company(company, %{
          last_run_time: DateTime.to_string(DateTime.utc_now()),
          last_run_status: 0
        })
    end
  end

  def fetch_api(process, company) do
    response = HTTPoison.get!(process["url"])
    {res, jd} = Jason.decode(response.body)

    if res == :error do
      raise "error while fetching details for companyid:" <> company.id
    end

    parent = case process["encloser"] do
      "" -> jd
      _ -> jd[process["encloser"]]
    end

    Enum.map(parent, fn j ->
      %{
        title: j[process["title"]],
        link: j[process["link"]],
        company_id: company.id
      }
    end)
  end

  def fetch_scrape(process, company) do
    response = Crawly.fetch(process["url"])
    doc = Floki.parse_document!(response.body)

    Floki.find(doc, process["encloser"])
    |> Enum.map(fn x ->
      %{
        title: Floki.find(x, process["title"]) |> Floki.text(),
        link:
          case process["link"] do
            "" -> Floki.attribute(x, "href") |> Floki.text()
            _ -> Floki.find(x, process["link"]) |> Floki.attribute("href") |> Floki.text()
          end,
        company_id: company.id
      }
    end)
  end
end
