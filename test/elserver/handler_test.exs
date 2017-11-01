defmodule Elserver.HandlerTest do
  use ExUnit.Case

  
  alias Elserver.Conversation 

  test "it should format response headers correctly" do 
    conversation = %Conversation{resp_headers: %{"Content-Type" => "application/json", "Content-Length" =>  394}}

    expected_headers ="Content-Type: application/json\r\nContent-Length: 394\r"

    assert Elserver.Handler.format_response_headers(conversation) == expected_headers
  end 

  test "it should handle api calls with json" do 
    request = """
    Get /api/sharks HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = Elserver.Handler.handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 394\r
    \r
    [{"type":"HammerHead Shark","name": "Bonzo", "id": 1, "hibernating": false},
     {"type":"Wobegonng","name":"Mud", "id":2, "hibernating": false},
     {"type":"Great White","name":"Pablo", "id":3, "hibernating": false},
     {"type":"Smooth Hound","name": "Ochoa", "id": 4 , "hibernating":false},
     {"type":"Thresher Shark","name":"Diana", "id":5, "hibernating":false}, 
     {"type":"Sand Shark","name":"Alex", "id":6, "hibernating":false}
    ]  
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end 

  test "it should handle calls" do 
    request = """
    Get /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = Elserver.Handler.handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 29\r
    \r
    Baboons, Trees, Eland, Sharks
    """
 
  
 
  end 

  test "it should return a 404 on paths that don't exist" do
    conversation = %Conversation{method: "Get", path: "/colors", status: nil,  resp_body: ""}
    assert Elserver.Handler.route(conversation) == %Conversation{method: "Get", path: "/colors", resp_body: "The path #{conversation.path} was not found on this server", status: 404} 
  end

  test "it should format a response correctly" do 
    conversation = %Conversation{method: "Get", path: "/colors", resp_headers: %{"Content-Length" => 7, "Content-Type" => "text/html"}, status: 200,  resp_body: "Ok Cool"}

    response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 7\r
    \r
    Ok Cool
    """
    assert Elserver.Handler.format_response(conversation) == response

  end  

  test "it should handle a delete request and return a response" do 
    conversation = %Conversation{method: "Delete", path: "/shark/102"}

    assert Elserver.Handler.route(conversation) == %Conversation{method: "Delete", path: "/shark/102", resp_body: "Deleting 102 ...", status: 202} 
  end

  test "it should handle a get post for a single shark" do 
    conversation = %Conversation{method: "Get", path: "/shark/1"}

    assert Elserver.Handler.route(conversation) == %Conversation{method: "Get", path: "/shark/1", resp_body: "<h1>Show Shark</h1>\n<p>\nIs Bonzo hibernating? <strong>false</strong>\n</p>\n", status: 200}
  
  end

  def remove_whitespace(text) do
   String.replace(text, ~r{\s}, "")
  end 

end 
