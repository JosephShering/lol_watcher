defmodule LolWatcher.RiotApi do
  @hosts %{
    "BRI" => "br1.api.riotgames.com",
    "EUN1" => "eun1.api.riotgames.com",
    "EUW1" => "euw1.api.riotgames.com",
    "JP1" => "jp1.api.riotgames.com",
    "KR" => "kr.api.riotgames.com",
    "LA1" => "la1.api.riotgames.com",
    "LA2" => "la2.api.riotgames.com",
    "NA1" => "na1.api.riotgames.com",
    "OC1" => "oc1.api.riotgames.com",
    "TR1" => "tr1.api.riotgames.com",
    "RU" => "ru.api.riotgames.com"
  }

  @regions %{
    "AMERICAS" => "americas.api.riotgames.com",
    "ASIA" => "asia.api.riotgames.com",
    "EUROPE" => "europe.api.riotgames.com"
  }

  defmacro __using__([]) do
    quote do
      use Tesla

      plug(Tesla.Middleware.JSON)

      plug(Tesla.Middleware.Query,
        api_key: Application.get_env(:lol_watcher, LolWatcher.RiotApi)[:api_key]
      )

      plug(Tesla.Middleware.Cache, ttl: :timer.seconds(30))

      import LolWatcher.RiotApi
    end
  end

  def hosts do
    Map.keys(@hosts)
  end

  def regions do
    Map.keys(@regions)
  end

  def hosts_map, do: @hosts

  def regions_map, do: @regions

  def fetch_host(host) do
    case Map.get(@hosts, host) do
      nil -> {:error, "Could not find host"}
      host -> {:ok, host}
    end
  end

  def fetch_region(region) do
    case Map.get(@regions, region) do
      nil -> {:error, "Could not find region"}
      region -> {:ok, region}
    end
  end
end
