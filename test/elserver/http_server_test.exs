defmodule Elserver.HttpTest do
  use ExUnit.Case 
  alias Elserver.HttpClient 
  alias Elserver.HttpServer

  test "server shold accept connection and respond" do 
    port = 4000
    spawn(HttpServer, :start, [port])

    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    
    response = HttpClient.response(port, request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 29\r
    \r
    Baboons, Trees, Eland, Sharks
    """
    assert response == expected_response

  end

end
