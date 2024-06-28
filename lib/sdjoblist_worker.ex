defmodule SdjoblistWorker.JobFetcher do
  alias SdjoblistWorker.Fetcher
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    realwork()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.info("Starting schedule task worker")
    realwork()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 2 * 60 * 60 * 1000)
  end

  defp realwork() do
    Fetcher.process()
  end
end
