defmodule Elserver.Api.SharkController do 
  def index(conv) do 
    json =
      Elserver.Wildthings.list_sharks()
      |> Poison.encode!
    %{conv | resp_content_type: "application/json", status: 200, resp_body: json}
  end 
end 
