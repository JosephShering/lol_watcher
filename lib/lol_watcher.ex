defmodule LolWatcher do
  @moduledoc """
  Documentation for `LolWatcher`.
  """

  require Logger

  alias LolWatcher.RiotApi.{Summoner, Match}

  def get_recent_players(summoner_name, host, region) do
    with {:ok, summoner} <- Summoner.by_name(summoner_name, host),
         {:ok, matches} <- Match.matches(summoner.puuid, region, count: 5) do
      Match.start_watching_player(summoner, matches, region)
      Match.recent_players_from_matches(matches, summoner_name)
    end
  end
end
