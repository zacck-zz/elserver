defmodule Elserver.PledgeServer do 

  @procname :pledge_server

  # Client Process  
  def start() do
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @procname)
    pid
  end 
  
  def create_pledge( name, amount) do 
    send @procname, {:create_pledge, name, amount}
  end

  def recent_pledges do
    send @procname, {self(), :recent_pledges}

    receive do {:response, pledges} -> pledges end
  end 

  def total_pledged do
    send @procname, {self(), :total_pledged}

    receive do {:response, total} -> total end
  end  

  #Server Process
  
  #use a process to continously monitor for a message 
  def listen_loop(state) do

    receive do
      {sender, :create_pledge, name, amount} ->  
        {:ok, id} = database_pledge(name, amount)
        recent_state = Enum.take(state, 2)
        current_state =  [{name, amount} | recent_state]
        send sender, {:response, id}
        listen_loop(current_state)
      {sender, :recent_pledges} ->
        send sender, {:response, state}
        listen_loop(state) 
      {sender, :total_pledged} ->
        total = &Enum.map(state, elem(&1, 1)) |> Enum.sum 
        send sender, {:total_pledged, total}
        listen_loop(state)
       unexpected -> 
        inspect unexpected
        listen_loop(state)
    end 
  end

  defp  database_pledge(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"} 
  end  

  

end 
