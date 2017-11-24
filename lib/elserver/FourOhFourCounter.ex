defmodule Elserver.FourOhFourCounter do 
  @counter :counter

  use GenServer 

  def start() do
    GenServer.start(__MODULE__, [], name: @counter)
  end 

  def bump_count(path) do   
    call @counter, {:bump_count, path}
  end

  def get_count(path) do 
    call @counter, {:get_count, path}
  end

  def get_counts do 
    call @counter, :get_counts
  end

  def call(pid, message) do
    send pid, {:call, self(), message}

    receive do {:response, response} ->  response end 
  end


  # Server interface
  def counter_loop(state) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = handle_call(message, state)
        send sender, {:response, response}
        counter_loop(new_state)
      unexpected ->
        counter_loop(state)
    end  
  end

  def handle_call({:bump_count, path}, _from, state) do
    current_state = [path | state]
    {:reply, :ok, current_state}
  end 

  def handle_call({:get_count,path}, _from,  state) do
    count =  Enum.count(state, fn(x) -> x == path end)
    {:reply, count, state}
  end 

  def handle_call(:get_counts, _from, state) do
    totals =  Enum.chunk_by(Enum.sort(state), &(&1))
    counts = Enum.reduce(totals, %{}, &(Map.put(&2, Enum.at(&1, 0), Enum.count(&1))))
    {:reply, counts, state}
  end 

   
end 
