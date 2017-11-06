defmodule Elserver.PledgeServer do 

  #persist data
  #def create_pledge(name, amount) do 
  # {:ok, id} = database_pledge(name, amount)
    # persist some state
    #  end 

    #def recent_pledges() do
    
    #end

  #use a process to continously monitor for a message 
  def listen_loop(state) do
    IO.puts "Waiting for a message"

    receive do
      {:create_pledge, name, amount} ->  
        {:ok, id} = database_pledge(name, amount)
        current_state =  [{name, amount} | state]
        IO.puts "#{name} plegded #{amount}"
        IO.puts "The state is now #{inspect(new_state)}"
        listen_loop(current_state)
      {sender, :recent_plegdes} ->
        send sender, {:response, state}
        listen_loop(state) 
    end 
  end 

  

  defp database_pledge(_name, _amount) do 
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end 
end 
