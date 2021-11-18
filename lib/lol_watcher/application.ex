defmodule LolWatcher.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: LolWatcher.RiotApi.Match.WatchRegistry},
      {LolWatcher.RiotApi.Match.WatchSupervisor, []}
    ]

    opts = [strategy: :one_for_one, name: LolWatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
