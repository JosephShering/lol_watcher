defmodule LolWatcherTest do
  use ExUnit.Case
  doctest LolWatcher

  test "greets the world" do
    assert LolWatcher.hello() == :world
  end
end
