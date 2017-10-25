defmodule Elserver.Parser do 
  alias Elserver.Conversation, as: Conversation
  @moduledoc """
  Parses a http request from a string to a conversation map
  """
  def parse(request) do
    #split params from request
    [header_lines, params_string] = String.split(request, "\n\n")


    #split request line from header lines 
    [request_line | request_headers] = String.split(header_lines, "\n")
  
    [method, path, _] =  String.split(request_line, " ")     
    

    params = parse_params(params_string)

    %Elserver.Conversation{ 
      method: method,
      path: path,
      params: params
    }  
  end 

  defp parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end 
end 
