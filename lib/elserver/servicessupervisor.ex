defmodule Elserver.ServicesSupervisor do
  use Supervisor 

  def start_link(_arg) do 
    IO.puts "Starting supervisor"
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end 

  def init(:ok) do
    children = [
      Elserver.PledgeServer,
      {Elserver.NodeServer, 600000},
      Elserver.FourOhFourCounter
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end 
end 
