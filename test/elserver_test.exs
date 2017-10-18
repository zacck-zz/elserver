defmodule ElserverTest do
  use ExUnit.Case
  doctest Elserver

  test "greets the world" do
    assert Elserver.hello() == :world
  end
end
