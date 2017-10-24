defmodule Elserver.Handler do
  
  @moduledoc "Handles Http Requests"

  import Elserver.Plugins,  only: [rewrite_path: 1, log: 1, track: 1, emojify: 1,]
  import Elserver.Parser, only: [parse: 1]
  import Elserver.FileHandler, only: [handle_file: 2]
  alias Elserver.Conversation 
  @pages_path Path.expand("pages", File.cwd!)

  @doc "Transforms the request into a response"
  def handle(request) do
    #pipe the request through the transformational functions in the server
    request 
    |> parse
    |> rewrite_path
    |> log 
    |> route
    |> emojify 
    |> track
    |> format_response
  end

 
#  def route(conv) do
#   route(conv, conv.method, conv.path)
# end
  
  def route(%Conversation{method: "Get", path: "/wildthings"} = conv) do 
   %{ conv | status: 200, resp_body: "Baboons, Trees, Eland, Sharks" } 
  end 


  def route(%Conversation{method: "Get", path: "/pages/" <> file} = conv) do
      @pages_path
      |> Path.join(file <> ".html")
      |> File.read
      |> handle_file(conv) 
  end 
  

  def route(%Conversation{method: "Get", path: "/sharks"} = conv) do 
    %{ conv | status: 200,  resp_body: "Great White, Tiger, HammerHead, Mini Sharks, Monky Sharks" }
  end

  def route(%Conversation{method: "Get", path: "/shark/" <> id } = conv) do 
    %{conv | status: 200, resp_body: "Shark #{id}"}
  end 

  def route(%Conversation{method: "Delete", path: "/shark/" <> id } = conv)  do
    %{conv | status: 202, resp_body: "Deleting #{id} ..."}
  end 

  def route(%Conversation{path: path} = conv) do 
    %{conv| status: 404, resp_body: "The path #{path} was not found on this server"}
  end

  def format_response(%Conversation{} = conv) do
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
      202 => "Accepted",
      204 => "No Content",
      401 => "Unauthorized",
      403 => "Forbidden", 
      404 => "Not Found",
      500 => "Internal Server Error", 
    }[code]
  end 

end 
request = """
Get /pages/form HTTP/1.1
Host: example.com 
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Elserver.Handler.handle(request)

IO.puts response



request = """
Get /pages/about HTTP/1.1
Host: example.com 
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Elserver.Handler.handle(request)

IO.puts response



request = """
Get /wildthings HTTP/1.1
Host: example.com 
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Elserver.Handler.handle(request)

IO.puts response

request = """
Get /wildlife HTTP/1.1
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


request = """
Get /shark/1 HTTP/1.1
Host: example.com 
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Elserver.Handler.handle(request)


IO.puts response

request = """
Get /shark?id=1 HTTP/1.1
Host: example.com 
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Elserver.Handler.handle(request)


IO.puts response



request = """
Delete /shark/102 HTTP/1.1
Host: example.com 
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Elserver.Handler.handle(request)


IO.puts response


