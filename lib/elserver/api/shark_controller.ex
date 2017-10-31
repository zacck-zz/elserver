defmodule Elserver.Api.SharkController do 
  def index(conv) do 
    json =
      Elserver.Wildthings.list_sharks()
      |> Poison.encode!

    conv = put_resp_content_type(conv, "application/json")

    %{conv | status: 200, resp_body: json}
  end 

  defp put_resp_content_type(conv, "application/json") do
    updated_headers =  Map.put(conv.resp_headers, "Content-Type", "application/json") 
    %{conv | resp_headers: updated_headers}
  end 
end 
