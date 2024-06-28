defmodule SdjoblistWorker.Fetcher do
  alias Sdjoblist.Companies

  def process() do

    companies = Companies.list_companies()
    for company <- companies do
      IO.inspect(company)
      process = Jason.decode(company.process)
      IO.inspect(process)
    end

  end

end
