defmodule Elserver.HttpTest do
  use ExUnit.Case 
  alias Elserver.HttpServer

  test "server shold accept connection and respond" do 
    port = 4000
    spawn(HttpServer, :start, [port])

    url = "http://localhost:#{port}/wildthings"

    1..5 
    |> Enum.map(fn(_) -> Task.async(fn -> HTTPoison.get(url) end) end) #run a task for each number to get the url 
    |> Enum.map(&Task.await/1) # for each task await a result 
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, resp}) do
    assert resp.status_code == 200
    assert resp.body == "Baboons, Trees, Eland, Sharks"
  end 

end
