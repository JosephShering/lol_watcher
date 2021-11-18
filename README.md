# LolWatcher

In order to start this project, fill in the `<your_api_key_here>` string on line 3 of the `config.exs` with your LOL API key.

Then run `iex -S mix run`
After IEX prompts for a command use: `LolWatcher.get_recent_players("<your_summoner_here>", "<host>", "<region>")`

This method will return a list of recently played players. Then will start a genserver to periodically watch.
