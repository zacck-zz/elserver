defmodule Elserver.Parser do 
  alias Elserver.Conversation, as: Conversation
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
    %Elserver.Conversation{ 
       method: method,
       path: path
    }  
  end 
end 
