defmodule Elserver.PledgeServer do 

  #persist data
  def create_pledge(name, amount) do 
    {:ok, id} = database_pledge(name, amount)
    # persist some state
  end 

  def recent_pledges() do
    
  end

  defp database_pledge(_name, _amount) do 
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end 
end 
