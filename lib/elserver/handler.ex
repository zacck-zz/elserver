defmodule Elserver.Handler do
  def handle(request) do
    #pipe the request through the transformational functions in the server
    request 
    |> parse
    |> log 
    |> route 
    |> format_response
  end

  def log(conv), do: IO.inspect conv

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
  
  def route(conv) do
    route(conv, conv.method, conv.path)
  end
  
  def route(conv, "Get", "/wildthings") do 
   %{ conv | status: 200, resp_body: "Baboons, Trees, Eland, Sharks" } 
  end 

  def route(conv, "Get", "/sharks") do 
    %{ conv | status: 200,  resp_body: "Great White, Tiger, HammerHead, Mini Sharks, Monky Sharks" }
  end 
    
 def route(conv, _method, path) do 
    %{conv| status: 404, resp_body: "The path #{path} was not found on this server"}
  end 

 

  def format_response(conv) do
    # Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  # define a private function using defp codes 
  defp status_reason(code) do 
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden", 
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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

request = """
Get /sharks HTTP/1.1
Host: example.com 
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Elserver.Handler.handle(request)


IO.puts response

request = """
Get /HammerHead HTTP/1.1
Host: example.com 
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Elserver.Handler.handle(request)


IO.puts response
