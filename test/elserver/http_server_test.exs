defmodule Elserver.HttpServerTest do
  use ExUnit.Case 
  alias Elserver.HttpServer

  test "server shold accept connection and respond" do 
    port = 4000
    spawn(HttpServer, :start, [port])
    
    # Stat node Server for node data 
    Elserver.NodeServer.start_link(60)

    urls = [
      "http://localhost:#{port}/wildthings",
      "http://localhost:#{port}/sharks",
      "http://localhost:#{port}/shark/1",
      "http://localhost:#{port}/nodedata",
      "http://localhost:#{port}/api/sharks"
    ]



    urls 
    |> Enum.map(fn(link) -> Task.async(fn -> HTTPoison.get(link) end) end) #run a task for each number to get the url 
    |> Enum.map(&Task.await/1) # for each task await a result 
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, resp}) do
    assert resp.status_code == 200
  end 

end
