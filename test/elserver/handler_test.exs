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


  test "it should route a request and return a body" do
    conversation = %{method: "Get", path: "/colors", resp_body: ""}
    assert Elserver.Handler.route(conversation) == %{method: "Get", path: "/colors", resp_body: "Red, Green, Blue"} 
  end  

end 
