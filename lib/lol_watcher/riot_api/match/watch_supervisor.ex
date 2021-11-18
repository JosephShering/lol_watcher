defmodule LolWatcher.RiotApi.Match.WatchSupervisor do
  use DynamicSupervisor

  alias LolWatcher.RiotApi.Match

  def start_watcher(summoner, matches, region) do
    DynamicSupervisor.start_child(__MODULE__, %{
      id: summoner.name,
      start:
        {Match.NewMatchWatcher, :start_link,
         [
           %{
             summoner: summoner,
             matches: matches,
             region: region
           }
         ]},
      restart: :transient
    })
  end

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
