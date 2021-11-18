defmodule LolWatcher.RiotApi.Match.NewMatchWatcher do
  use GenServer, restart: :transient

  require Logger

  # LolWatcher.get_recent_players("Zud", "NA1", "AMERICAS")

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: via_tuple(args.summoner.name))
  end

  @impl true
  def handle_info(
        :fetch_new_match,
        %{summoner: summoner, region: region, matches: matches} = state
      ) do
    {:ok, latest_matches} = LolWatcher.RiotApi.Match.matches(summoner.puuid, region, count: 5)

    newly_completed_matches =
      Enum.reject(latest_matches, fn latest_match ->
        Enum.find(matches, fn match ->
          match.metadata.match_id == latest_match.metadata.match_id
        end) != nil
      end)

    newly_completed_matches
    |> Enum.map(fn match ->
      IO.puts("Summoner #{summoner.name} completed match #{match.metadata.match_id}")
    end)

    schedule_fetch_matches()

    {:noreply, Map.put(state, :matches, matches ++ newly_completed_matches)}
  end

  @impl true
  def handle_info(:shutdown, state) do
    {:stop, :normal, state}
  end

  @impl true
  def init(args) do
    schedule_fetch_matches()
    schedule_shutdown()
    {:ok, args}
  end

  def via_tuple(summoner_name) do
    {:via, Registry, {LolWatcher.RiotApi.Match.WatchRegistry, summoner_name}}
  end

  defp schedule_shutdown() do
    Process.send_after(
      self(),
      :shutdown,
      Application.get_env(:lol_watcher, LolWatcher.RiotApi.Match.NewMatchWatcher)[:shutdown_in]
    )
  end

  defp schedule_fetch_matches() do
    interval =
      Application.get_env(:lol_watcher, LolWatcher.RiotApi.Match.NewMatchWatcher)[:interval]

    Process.send_after(self(), :fetch_new_match, interval)
  end
end
