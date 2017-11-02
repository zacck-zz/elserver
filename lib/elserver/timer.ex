defmodule Timer do 
  def remind(msg, time) do
    spawn(fn -> :timer.sleep(time); IO.puts "time to #{msg}" end)
  end
end 
