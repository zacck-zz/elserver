defmodule Elserver.HandlerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "it should parse the request into a map" do 
    request = """
    Get /wildthings HTTP/1.1
    Host: example.com 
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    assert Elserver.Handler.parse(request) == %{method: "Get", path: "/wildthings", resp_body: "", status: nil}
  end


  test "it should return a 404 on paths that don't exist" do
    conversation = %{method: "Get", path: "/colors", status: nil,  resp_body: ""}
    assert Elserver.Handler.route(conversation) == %{method: "Get", path: "/colors", resp_body: "The path #{conversation.path} was not found on this server", status: 404} 
  end 

  test "it should rewrite a path with url parameters" do
    conversation =  %{method: "Get", path: "/mice?id=1", status: nil, resp_body: ""}
    assert Elserver.Handler.rewrite_path(conversation) == %{conversation | path: "/mice/1"}
  end 

  test "the tracker should return an unmodified conversation " do 
    conversation = %{method: "Get", path: "/colors", resp_body: "The path /colors was not found on this server", status: 404} 
    assert Elserver.Handler.track(conversation) == conversation
  end 

   



end 
