defmodule Elserver.HttpTest do
  use ExUnit.Case 
  alias Elserver.HttpServer

  test "server shold accept connection and respond" do 
    port = 4000
    spawn(HttpServer, :start, [port])
    
    {:ok, response} = HTTPoison.get "http://localhost:#{port}/wildthings" 

    assert response.body == "Baboons, Trees, Eland, Sharks"
    assert response.status_code  == 200

  end

end
