defmodule Elserver.HandlerTest do
  use ExUnit.Case

  test "it should parse the request into a map" do 
    request = """
    Get /wildthings HTTP/1.1
    Host: example.com 
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    assert Elserver.Handler.parse(request) == %{method: "Get", path: "/wildthings", resp_body: ""}
  
  end 

end 
