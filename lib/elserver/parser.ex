defmodule Elserver.Parser do 
  @moduledoc """
  Parses a http request from a string to a conversation map
  """
  def parse(request) do
    #Parse the request string into a map:
    [method, path, _] = 
      request 
      |> String.split("\n") 
      |> List.first
      |> String.split(" ")
    %{ method: method,
       path: path,
       resp_body: "",
       status: nil 
     }  
  end 
end 
