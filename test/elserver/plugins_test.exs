defmodule Elserver.PluginsTest do
 use ExUnit.Case 

  import ExUnit.CaptureIO 
  alias Elserver.Conversation
  alias Elserver.Plugins 
  
  test "it should rewrite a path with url parameters" do
    conversation =  %Conversation{method: "GET", path: "/mice?id=1", status: nil, resp_body: ""}
    assert Plugins.rewrite_path(conversation) == %Conversation{conversation | path: "/mice/1"}
  end 

  
  test "the tracker should return an unmodified conversation with 404 status" do 
    conversation = %Conversation{method: "GET", path: "/colors", resp_body: "The path /colors was not found on this server", status: 404} 
    assert Plugins.track(conversation) == conversation
    assert capture_io(fn() -> Elserver.Plugins.track(conversation) end) == "Warning: /colors does not exist on this server\n"
  end

  test "/wildlife path should be rewritten to /wildthings" do
    conversation = %Conversation{method: "GET", path: "/wildlife", resp_body: "The path /colors was not found on this server", status: 404} 
    assert Plugins.rewrite_path(conversation) == %Conversation{method: "GET", path: "/wildthings", resp_body: "The path /colors was not found on this server", status: 404} 
  end 


  test "the tracker should return unmodified conversation with 200 status" do
    conversation = %Conversation{method: "GET", path: "/colors", resp_body: "The path /colors was not found on this server", status: 200}

   assert Plugins.track(conversation) == conversation 
  end   

  test "emojify should apply emojis" do 
    conversation = %Conversation{method: "GET", path: "/colors", resp_body: "emoji", status: 200}
    assert Plugins.emojify(conversation) ==  %Conversation{method: "GET", path: "/colors", resp_body: "😎emoji😎", status: 200} 
  end

  test "emojify should return unmodified conversation if status is not 200" do 
   conversation =  %Conversation{method: "GET", path: "/colors", resp_body: "emoji", status: 201}
   assert Plugins.emojify(conversation) == conversation  
  end  
end
