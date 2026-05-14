defmodule Oopserver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OopserverWeb.Telemetry,
      Oopserver.Repo,
      {DNSCluster, query: Application.get_env(:oopserver, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Oopserver.PubSub},
      # Reproducer: launching any Cachex instance ensures :cachex is fully
      # started, which transitively starts :ex_hash_ring. Strictly speaking,
      # listing :cachex as a dep is enough — mix auto-starts dep applications —
      # but a real cache makes the supervision tree look like a normal app.
      {Cachex, name: :demo_cache},
      # Start a worker by calling: Oopserver.Worker.start_link(arg)
      # {Oopserver.Worker, arg},
      # Start to serve requests, typically the last entry
      OopserverWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Oopserver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OopserverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
