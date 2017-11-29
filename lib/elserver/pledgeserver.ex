defmodule Elserver.PledgeServer do 

  @procname :pledge_server

  use GenServer 

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end 

  # Client Process
  def start_link(_arg) do
   IO.puts "Starting the PledgeServer"
   GenServer.start_link(__MODULE__, %State{}, name: @procname)
  end 

  def create_pledge( name, amount) do 
    GenServer.call @procname, {:create_pledge, name, amount}
  end

  def clear do 
    GenServer.cast @procname, :clear
  end

  def set_cache_size(size) do
    GenServer.cast @procname, {:set_cache_size, size}
  end  

  def recent_pledges do
    GenServer.call @procname, :recent_pledges
  end 

  def total_pledged do
    send @procname, :total_pledged
  end  


  # Server Callbacks
  
  def init(state) do
    pledges = fetch_state 
    new_state =  %{ state | pledges: pledges }
    {:ok, new_state} 
  end 

  def handle_cast(:clear, _from, state) do
    {:noreply, %{ state | pledges: []}}
  end 

  def handle_cast({:set_cache_size, size}, _from, state) do
    pledges = Enum.take(state.pledges, size)
    {:noreply, %{ state | pledges: pledges, cache_size: size}}
  end 

  def handle_call(:total_pledged, _from,  state) do
    total = &Enum.map(state.pledges, elem(&1, 1)) |> Enum.sum 
    {:reply, total, state}
  end
  
  def handle_call(:recent_pledges, _from, state) do 
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from,  state) do 
    {:ok, id} = database_pledge(name, amount)
    recent_state = Enum.take(state.pledges, state.cache_size - 1 )
    current_state =  [{name, amount} | recent_state]
    new_state = %{ state | pledges: current_state }
    {:reply, id, new_state}
  end  

  defp  database_pledge(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"} 
  end  

  defp fetch_state do
    [{"Zacck", 20}, {"Carla", 100}]
  end 
  

end 
