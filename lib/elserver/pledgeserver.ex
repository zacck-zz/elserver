defmodule Elserver.PledgeServer do 

  @procname :pledge_server

  import Elserver.GenericServer, only: [call: 2, cast: 2]

  # Client Process
  def start do
   Elserver.GenericServer.start(__MODULE__, [], @procname)
  end 

  def create_pledge( name, amount) do 
    call @procname, {:create_pledge, name, amount}
  end

  def clear do 
    cast @procname, :clear
  end 

  def recent_pledges do
    call @procname, :recent_pledges
  end 

  def total_pledged do
    send @procname, :total_pledged
  end  


  # Server Callbacks
  
  def handle_cast(:clear, _state) do
    []
  end 

  def handle_call(:total_pledged, state) do
    total = &Enum.map(state, elem(&1, 1)) |> Enum.sum 
    {total, state}
  end
  
  def handle_call(:recent_pledges, state) do 
    {state, state}
  end

  def handle_call({:create_pledge, name, amount},  state) do 
    {:ok, id} = database_pledge(name, amount)
    recent_state = Enum.take(state, 2)
    current_state =  [{name, amount} | recent_state]
    {id, current_state}
  end  

  defp  database_pledge(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"} 
  end  

  

end 
