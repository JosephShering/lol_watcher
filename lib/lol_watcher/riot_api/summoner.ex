defmodule LolWatcher.RiotApi.Summoner do
  use LolWatcher.RiotApi

  defstruct name: "", id: "", puuid: "", host: ""

  def by_name(summoner_name, host) do
    with {:ok, host_url} <- fetch_host(host),
         {:ok, %{status: 200, body: body}} <-
           get("https://#{host_url}/lol/summoner/v4/summoners/by-name/#{summoner_name}") do
      {:ok,
       %__MODULE__{
         id: body["id"],
         name: body["name"],
         puuid: body["puuid"],
         host: host_url
       }}
    else
      {:ok, %{status: status}} ->
        {:error, status}
    end
  end
end
