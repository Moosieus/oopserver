defmodule Oopserver.Repo do
  use Ecto.Repo,
    otp_app: :oopserver,
    adapter: Ecto.Adapters.Postgres
end
