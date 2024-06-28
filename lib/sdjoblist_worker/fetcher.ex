defmodule SdjoblistWorker.Fetcher do
  alias Sdjoblist.Jobs
  alias Sdjoblist.Companies

  def process() do

    companies = Companies.list_companies()
    for company <- companies do
      IO.inspect(company)
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
            url: Floki.find(x, process["link"]) |> Floki.attribute("href") |> Floki.text()
          }
        end)
      existingjobs = Jobs.get_company_job(company.id)
    end

  end

end
