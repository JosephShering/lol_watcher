import Config

config :lol_watcher, LolWatcher.RiotApi, api_key: "<your_api_key_here>"

config :lol_watcher, LolWatcher.RiotApi.Match.NewMatchWatcher,
  shutdown_in: :timer.hours(1),
  interval: :timer.minutes(1)
