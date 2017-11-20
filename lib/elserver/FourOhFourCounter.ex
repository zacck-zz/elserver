defmodule Elserver.FourOhFourCounter do 
  @counter :counter

  def start() do
    pid = spawn(__MODULE__, :counter_loop, [[]]) 
    Process.register(pid, @counter)
    pid 
  end 

  def bump_count(path) do
    if Process.whereis(@counter) == nil do
      start()
    end 
    send @counter, {self(), :bump_count, path}

    receive do {:response, count} -> count end
  end

  def get_count(path) do 
    send @counter, {self(), :get_count, path}

    receive do {:response, count} -> count end
  end

  def get_counts do 
    send @counter, {self(), :get_counts}

    receive do {:response, counts} -> counts end
  end 



  # Server interface
  def counter_loop(state) do
    receive do
      {sender, :bump_count, path} ->
        current_state = [path | state]
        send sender, {:response, Enum.count(current_state)}
        counter_loop(current_state)
      {sender, :get_count, path} -> 
      send sender, {:response, Enum.count(state, fn(x) ->  x == path end)}
        counter_loop(state)
      {sender, :get_counts} -> 
        totals =  Enum.chunk_by(Enum.sort(state), &(&1))
        counts = Enum.reduce(totals, %{}, &(Map.put(&2, Enum.at(&1, 0), Enum.count(&1))))
        send sender, {:response, counts}
        counter_loop(state)
      unexpected ->
        counter_loop(state)
    end  
  end 
end 
