defmodule Elserver.Fetcher do

  def async(fun) do 
    parent = self() # the process handling the current request

    spawn(fn -> send(parent, {self(), :result, fun.()}) end)
  end

  def get_result(pid) do
    receive do {^pid, :result, value} -> value end
  end
end 
