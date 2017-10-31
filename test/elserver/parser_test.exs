defmodule Elserver.ParserTest do 
  use ExUnit.Case
  alias Elserver.Conversation
    test "it should parse the request into a map" do 
      request = """
      GET /wildthings HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      assert Elserver.Parser.parse(request) == %Conversation{method: "GET", headers: %{"Accept" =>  "*/*", "Host" =>  "example.com", "User-Agent" => "ExampleBrowser/1.0"}, path: "/wildthings", resp_body: "", status: nil}
    end

  test "it should parse url encoded params " do 
    request = """
    Post /sharks/ HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 16\r
    \r
    name=Great&type=white
    """

    assert Elserver.Parser.parse(request).params ==  %{"name" => "Great", "type" =>  "white"}
 
  end

  test "it should parse headers list into a map of headers" do 
    headers = [
      "Host: example.com", 
      "User-Agent: ExampleBrowser/1.0",
      "Accept: */*",
      "Content-Type: application/x-www-form-urlencoded",
      "Content-Length: 16"
    ]
    assert Elserver.Parser.parse_headers(headers) == %{"Host" =>  "example.com", "User-Agent" => "ExampleBrowser/1.0", "Accept" =>  "*/*", "Content-Type" =>  "application/x-www-form-urlencoded", "Content-Length" => "16"}
  end  

end 
