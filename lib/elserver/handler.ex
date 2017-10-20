defmodule Elserver.Handler do
  def handle(request) do
    #pipe the request through the transformational functions in the server
    request 
    |> parse 
    |> route 
    |> format_response
  end

  def parse(request) do
    #Parse the request string into a map:
    [method, path, _] = 
      request 
      |> String.split("\n") 
      |> List.first
      |> String.split(" ")
    %{ method: method, path: path, resp_body: "" }  
  end
  
  #last expression of a variable is implicitly returned
 
  def route(conv) do
    #Create a new map that also has the response body:
    %{ conv | resp_body: "Baboons, Trees, Eland" }
  end

  def format_response(conv) do
    # Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end


end 
request = """
Get /wildthings HTTP/1.1
Host: example.com 
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Elserver.Handler.handle(request)

IO.puts response
