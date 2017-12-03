defmodule Elserver do
  use Application

  def start(_type, _args) do
    IO.puts "Starting Elserver"
    Elserver.Supervisor.start_link()
  end 
end


