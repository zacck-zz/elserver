defmodule Elserver.SharkControllerTest do 
  use ExUnit.Case

  alias Elserver.SharkController
  alias Elserver.Conversation 

  test "delete action should delete a resource and return the correct message" do 
    conversation = %Conversation{
      method: "Delete",
      path: "/shark/102",
    }

    result = %Conversation{
      method: "Delete",
      status: 202,
      path: "/shark/102",
      resp_body: "Deleting 102 ..."
    }

    assert SharkController.delete(conversation, %{"id" => 102}) == result
  end 
end 
