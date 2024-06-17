defmodule Sdjoblist.Repo do
  use Ecto.Repo,
    otp_app: :sdjoblist,
    adapter: Ecto.Adapters.SQLite3
end
