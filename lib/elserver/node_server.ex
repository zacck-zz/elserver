defmodule Elserver.NodeServer do 
  
  @name :nodey_server 
  
  use GenServer 

  # State 
  defmodule State do 
    defstruct node_data: %{}, refresh_interval: :timer.minutes(60)
  end 


  # Client Interface 

  def start_link(arg) do
    #start with an empty map as state 
    IO.puts "Starting #{@name} server"
    GenServer.start_link(__MODULE__, %State{refresh_interval: arg }, name: @name)
  end 

  def get_node_data do 
    GenServer.call @name, :get_node_data 
  end

  def set_refresh_interval(time) do 
    Genserver.cast @name, {:set_refresh_interval, time}
  end  

  # Server Callbacks 

  def init(state) do 
    initial_state = %{ state | node_data: run_tasks_to_get_node_data() }
    schedule_refresh(state.refresh_interval)
    {:ok, initial_state}
  end 

  def handle_call(:get_node_data, _from, state) do
    {:reply, state.node_data, state}
  end  

  def handle_info(:refresh, state) do
    IO.puts "Refreshing the cache now"
    new_state = %{state | node_data: run_tasks_to_get_node_data}
    schedule_refresh(state.refresh_interval)
    {:noreply, new_state}
  end 

  def handle_cast({:set_refresh_interval, time}, state) do
    new_state = %{ state | refresh_interval: time }
    {:noreply, new_state}
  end 

  def run_tasks_to_get_node_data do 
    nodes =
      ["node_1", "node_2", "node_3"]
      |> Enum.map(&Task.async(Elserver.Node, :get_data, [&1] ))
      |> Enum.map(&Task.await/1)
    
    location_task = Task.async(Elserver.Tracker, :get_location, ["bigfoot"])

    where_is_bigfoot = Task.await(location_task)
    %{nodes: nodes, location: where_is_bigfoot} 
  end 
  
  defp schedule_refresh(time) do
    Process.send_after(self(), :refresh, time)
  end 

end 
