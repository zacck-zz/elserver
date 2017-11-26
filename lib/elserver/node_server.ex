defmodule Elserver.NodeServer do 
  
  @name :nodey_server 
  @refresh_interval :timer.seconds(5)
  
  use GenServer 

  # Client Interface 

  def start do
    #start with an empty map as state 
    GenServer.start(__MODULE__, %{}, name: @name)
  end 

  def get_node_data do 
    GenServer.call @name, :get_node_data 
  end 

  # Server Callbacks 

  def init(_state) do 
    initial_state = run_tasks_to_get_node_data()
    schedule_refresh()
    {:ok, initial_state}
  end 

  def handle_call(:get_node_data, _from, state) do
    {:reply, state, state}
  end  

  def handle_info(:refresh, _state) do
    IO.puts "Refreshing the cache now"
    new_state = run_tasks_to_get_node_data
    schedule_refresh()
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
  
  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end 

end 
