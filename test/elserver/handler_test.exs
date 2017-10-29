defmodule Elserver.HandlerTest do
  use ExUnit.Case
  alias Elserver.Conversation 


  test "it should return a 404 on paths that don't exist" do
    conversation = %Conversation{method: "Get", path: "/colors", status: nil,  resp_body: ""}
    assert Elserver.Handler.route(conversation) == %Conversation{method: "Get", path: "/colors", resp_body: "The path #{conversation.path} was not found on this server", status: 404} 
  end

  test "it should format a response correctly" do 
    conversation = %Conversation{method: "Get", path: "/colors", status: 200,  resp_body: "Ok Cool"}

    response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 7

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

end 
