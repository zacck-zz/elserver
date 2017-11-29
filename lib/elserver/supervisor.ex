defmodule Elserver.Supervisor do 
  use Supervisor

  def start_link do 
    IO.puts "Starting top level Supervisor"
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end 

  def init(:ok) do
    children = [
      Elserver.KickStarter, 
      Elserver.ServicesSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end 
end 
