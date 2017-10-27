defmodule Elserver.Wildthings do 
  alias Elserver.Shark 

  def list_sharks do 
    [
      %Shark{id: 1, name: "Bonzo", type: "HammerHead Shark" },
      %Shark{id: 2, name: "Mud", type: "Wobegonng" },
      %Shark{id: 3, name: "Pablo", type: "Great White" },
      %Shark{id: 4, name: "Ochoa", type: "Smooth Hound" },
      %Shark{id: 5, name: "Diana", type: "Thresher Shark" },
      %Shark{id: 6, name: "Alex", type: "Sand Shark" } 
    ]
  end

  def get_shark(id) when  is_integer(id) do
    Enum.find(list_sharks(), fn(shark) ->  shark.id == id end)
  end 

  def get_shark(id) when is_binary(id) do 
    id |> String.to_integer |> get_shark
  end 
end 
