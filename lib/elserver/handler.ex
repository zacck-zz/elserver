defmodule Elserver.Handler do
  
  @moduledoc "Handles Http Requests"

  import Elserver.Plugins,  only: [rewrite_path: 1, track: 1] 
  import Elserver.Parser, only: [parse: 1]
  import Elserver.FileHandler, only: [handle_file: 2]
  alias Elserver.Conversation 
  alias Elserver.SharkController 
  @pages_path Path.expand("pages", File.cwd!)

  @doc "Transforms the request into a response"
  def handle(request) do
    #pipe the request through the transformational functions in the server
    request 
    |> parse
    |> rewrite_path
    |> route
    |> track
    |> put_content_length
    |> format_response
  end
 
  def route(%Conversation{ method: "GET", path: "/kaboom" } = conv ) do 
    raise "Kaboom!"
  end 
 

  
  def route(%Conversation{ method: "GET", path: "/hibernate/" <> time } = conv ) do 
    time |> String.to_integer |>  :timer.sleep
    %{conv | status: 200, resp_body: "Done Processing"}
  end 
 
  # name=Great&type=white
  def route(%Conversation{method: "POST", path: "/sharks/"} = conv) do
    SharkController.create(conv)
  end 

 
  def route(%Conversation{method: "GET", path: "/wildthings"} = conv) do 
   %{ conv | status: 200, resp_body: "Baboons, Trees, Eland, Sharks" } 
  end 


  def route(%Conversation{method: "GET", path: "/pages/" <> file} = conv) do
      @pages_path
      |> Path.join(file <> ".html")
      |> File.read
      |> handle_file(conv) 
  end 
  

  def route(%Conversation{method: "GET", path: "/sharks"} = conv) do 
    SharkController.index(conv)
  end

  def route(%Conversation{method: "GET", path: "/api/sharks"} = conv) do 
    Elserver.Api.SharkController.index(conv)
  end


  def route(%Conversation{method: "GET", path: "/shark/" <> id } = conv) do 
    params = Map.put(conv.params, "id", id)
    SharkController.show(conv, params)
  end 

  def route(%Conversation{method: "Delete", path: "/shark/" <> id } = conv)  do
    params = Map.put(conv.params, "id", id)
    SharkController.delete(conv, params)
  end 

  def route(%Conversation{path: path} = conv) do 
    %{conv| status: 404, resp_body: "The path #{path} was not found on this server"}
  end

  def put_content_length(conv) do 
    updated_headers =  Map.put(conv.resp_headers, "Content-Length", byte_size(conv.resp_body))
    %{conv | resp_headers: updated_headers}
  end
  def format_response(%Conversation{} = conv) do
    # Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{Conversation.full_status(conv)}\r
    Content-Type: #{conv.resp_headers["Content-Type"]}\r
    Content-Length: #{conv.resp_headers["Content-Length"]}\r
    \r
    #{conv.resp_body}
    """
  end

end 


