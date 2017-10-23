defmodule Elserver.HandlerTest do
  use ExUnit.Case

  test "it should return a 404 on paths that don't exist" do
    conversation = %{method: "Get", path: "/colors", status: nil,  resp_body: ""}
    assert Elserver.Handler.route(conversation) == %{method: "Get", path: "/colors", resp_body: "The path #{conversation.path} was not found on this server", status: 404} 
  end 

end 
