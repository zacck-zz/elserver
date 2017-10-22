defmodule Elserver.Handler do
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

  # logger
  def track(%{status: 404, path: path} = conv) do 
    IO.puts "Warning: #{path} does not exist on this server"
    conv
  end 

  def track(conv), do: conv

  # path rewrites 
  def rewrite_path(%{path: "/wildlife"} = conv) do 
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path) 
    rewrite_path_captures(conv, captures)
  end 
  
  def rewrite_path(conv), do: conv

  # emojify response 
  def emojify(%{status: 200 } = conv) do
    %{conv | resp_body: "😎  #{conv.resp_body} 😎"}
  end 

  def emojify(conv), do: conv

  # use path captures in path 
  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    log(conv) 
    %{conv | path: "/#{thing}/#{id}"}
  end 

  def rewrite_path_captures(conv, nil), do: conv 

  
  # Inspect
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
  
#  def route(conv) do
#   route(conv, conv.method, conv.path)
# end
  
  def route(%{method: "Get", path: "/wildthings"} = conv) do 
   %{ conv | status: 200, resp_body: "Baboons, Trees, Eland, Sharks" } 
  end 

  def route(%{method: "Get", path: "/pages/" <> file} = conv) do
      Path.expand("../../pages", __DIR__)
      |> Path.join(file <> ".html")
      |> File.read
      |> handle_file(conv) 
  end 
  
  def handle_file({:ok, content}, conv) do 
    %{conv | status: 200, resp_body: content}
  end 

  def handle_file({:error, :enoent}, conv) do 
    %{conv | status: 404, resp_body: "The file #{conv.path} does not exist"}
  end 

  def handle_file({:error, reason}, conv) do 
    %{conv | status: 500, resp_body: "File Errror: #{reason}"}
  end 


  def route(%{method: "Get", path: "/sharks"} = conv) do 
    %{ conv | status: 200,  resp_body: "Great White, Tiger, HammerHead, Mini Sharks, Monky Sharks" }
  end

  def route(%{method: "Get", path: "/shark/" <> id } = conv) do 
    %{conv | status: 200, resp_body: "Shark #{id}"}
  end 

  def route(%{method: "Delete", path: "/shark/" <> id } = conv)  do
    %{conv | status: 202, resp_body: "Deleting #{id} ..."}
  end 

  def route(%{path: path} = conv) do 
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


