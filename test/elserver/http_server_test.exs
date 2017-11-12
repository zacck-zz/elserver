defmodule Elserver.HttpTest do
  use ExUnit.Case 
  alias Elserver.HttpServer

  test "server shold accept connection and respond" do 
    port = 4000
    spawn(HttpServer, :start, [port])
    
    parent = self()

    max_concurrent  = 5 

    for _ <- 1..max_concurrent do
      spawn(fn -> 
        {:ok, response} = HTTPoison.get "http://localhost:#{port}/wildthings" 
        send(parent, {:ok, response})
      end)
    end 

    for _ <- 1..max_concurrent do
      receive do
        {:ok, response} ->
          assert response.body == "Baboons, Trees, Eland, Sharks"
          assert response.status_code  == 200
      end
    end 

  end

end
