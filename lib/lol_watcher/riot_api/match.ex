defmodule LolWatcher.RiotApi.Match do
  use LolWatcher.RiotApi
  alias LolWatcher.RiotApi.Match
  alias LolWatcher.RiotApi.Match.{Participant, Info, Metadata}

  defstruct info: %Info{}, metadata: %Metadata{}

  def matches(puuid, region, query \\ []) do
    with {:ok, region_url} <- fetch_region(region),
         {:ok, %{status: 200, body: body}} <-
           get("https://#{region_url}/lol/match/v5/matches/by-puuid/#{puuid}/ids", query: query) do
      {:ok,
       body
       |> Flow.from_enumerable(max_demand: 2)
       |> Flow.map(&match(&1, region))
       |> Flow.filter(&match?({:ok, _}, &1))
       |> Flow.map(&elem(&1, 1))
       |> Enum.to_list()}
    else
      {:ok, %{status: status}} ->
        {:error, status}
    end
  end

  def match(match_id, region) do
    with {:ok, region_url} <- fetch_region(region),
         {:ok, %{status: 200, body: body}} <-
           get("https://#{region_url}/lol/match/v5/matches/#{match_id}") do
      {:ok,
       %__MODULE__{
         metadata: %Metadata{
           match_id: body["metadata"]["matchId"]
         },
         info: %Info{
           participants:
             Enum.map(body["info"]["participants"], fn p ->
               %Participant{
                 summoner_name: p["summonerName"]
               }
             end)
         }
       }}
    else
      {:ok, %{status: status}} ->
        {:error, status}
    end
  end

  def recent_players_from_matches(matches, summoner_name) do
    matches
    |> Enum.flat_map(fn match ->
      match.info.participants
    end)
    |> Enum.reject(&(&1.summoner_name == summoner_name))
    |> Enum.map(& &1.summoner_name)
  end

  def start_watching_player(summoner, matches, region) do
    Match.WatchSupervisor.start_watcher(summoner, matches, region)
  end
end
