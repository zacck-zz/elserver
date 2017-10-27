defmodule Elserver.ParserTest do 
  use ExUnit.Case
  alias Elserver.Conversation
    test "it should parse the request into a map" do 
      request = """
      Get /wildthings HTTP/1.1
      Host: example.com 
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert Elserver.Parser.parse(request) == %Conversation{method: "Get", headers: %{"Accept" =>  "*/*", "Host" =>  "example.com", "User-Agent" => "ExampleBrowser/1.0"}, path: "/wildthings", resp_body: "", status: nil}
    end

  test "it should parse url encoded params " do 
    request = """
    Post /sharks/ HTTP/1.1
    Host: example.com 
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded 
    Content-Length: 16

    name=Great&type=white
    """

    assert Elserver.Parser.parse(request).params ==  %{"name" => "Great", "type" =>  "white"}
 
  end 

end 
