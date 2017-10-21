defmodule ElserverTest do
  use ExUnit.Case

  test "greets the world" do
    name = "Zacck"
    assert Elserver.hello(name) == "Howdy #{name} from Elixir!"
  end
end
