defmodule SdjoblistWorker.Fetcher do
  alias Sdjoblist.Jobs
  alias Sdjoblist.Companies

  def process() do

    companies = Companies.list_companies()
    for company <- companies do
      {res, process} = Jason.decode(company.process)
      if res == :error do
        :error
      end
      response = Crawly.fetch(process["url"])
      doc = Floki.parse_document!(response.body)
      res = Floki.find(doc, process["encloser"])
        |> Enum.map(fn x ->
          %{
            title: Floki.find(x, process["title"]) |> Floki.text(),
            link: Floki.find(x, process["link"]) |> Floki.attribute("href") |> Floki.text(),
            company_id: company.id
          }
        end)
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
    end

  end

end
