defmodule Elserver.PluginsTest do
 use ExUnit.Case 
  test "it should rewrite a path with url parameters" do
    conversation =  %{method: "Get", path: "/mice?id=1", status: nil, resp_body: ""}
    assert Elserver.Plugins.rewrite_path(conversation) == %{conversation | path: "/mice/1"}
  end 

  test "the tracker should return an unmodified conversation " do 
    conversation = %{method: "Get", path: "/colors", resp_body: "The path /colors was not found on this server", status: 404} 
    assert Elserver.Plugins.track(conversation) == conversation
  end 


end
