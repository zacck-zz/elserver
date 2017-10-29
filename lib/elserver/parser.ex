defmodule Elserver.Parser do 
  alias Elserver.Conversation, as: Conversation
  @moduledoc """
  Parses a http request from a string to a conversation map
  """
  def parse(request) do
    #split params from request
    [header_lines, params_string] = String.split(request, "\r\n\r\n")
    
    #split request line from header lines 
    [request_line | request_headers] = String.split(header_lines, "\r\n")
    
    [method, path, _] =  String.split(request_line, " ")     
    

    headers = parse_headers(request_headers)
    
    params = parse_params(headers["Content-Type"],params_string)

    %Elserver.Conversation{ 
      method: method,
      path: path,
      params: params,
      headers: headers
    }  
  end 

  defp parse_params("application/x-www-form-urlencoded",params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  defp parse_params(_,_), do: %{}

  def parse_headers(header_list) do
    Enum.reduce(header_list, %{}, fn(header, collected_headers) -> 
      [key, value] = String.split(header, ": ")
      Map.put(collected_headers, key, String.trim(value)) 
    end) 
  end 

end 
