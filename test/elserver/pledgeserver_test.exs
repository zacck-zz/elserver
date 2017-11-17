defmodule Elserver.PledgeServerTest do 
  use ExUnit.Case

  alias Elserver.PledgeServer


  test "it should only cache the 3 most recent items" do 
    PledgeServer.start()

    for i <- 1..5 do
      PledgeServer.create_pledge("name#{i}", i)
    end

    assert Enum.count(PledgeServer.recent_pledges()) == 3     
  end 
end 
