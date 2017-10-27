defmodule Elserver.PluginsTest do
 use ExUnit.Case 

  import ExUnit.CaptureIO 
  alias Elserver.Conversation 
  
  test "it should rewrite a path with url parameters" do
    conversation =  %Conversation{method: "Get", path: "/mice?id=1", status: nil, resp_body: ""}
    assert Elserver.Plugins.rewrite_path(conversation) == %Conversation{conversation | path: "/mice/1"}
  end 

  test "the tracker should return an unmodified conversation with 404 status" do 
    conversation = %Conversation{method: "Get", path: "/colors", resp_body: "The path /colors was not found on this server", status: 404} 
    assert Elserver.Plugins.track(conversation) == conversation
    assert capture_io(fn() -> Elserver.Plugins.track(conversation) end) == "Warning: /colors does not exist on this server\n"
  end

  test "the tracker should return unmodified conversation with 200 status" do
    conversation = %Conversation{method: "Get", path: "/colors", resp_body: "The path /colors was not found on this server", status: 200}

   assert Elserver.Plugins.track(conversation) == conversation 
 
  end   


end
