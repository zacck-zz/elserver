defmodule Elserver.SharkController do 
  alias Elserver.Wildthings

  def index(conv) do
    items = 
      Wildthings.list_sharks()
      |> Enum.map(fn shark -> "<li>#{shark.name} - #{shark.type}</li>" end)
      |> Enum.join

    %{ conv | status: 200,  resp_body: "<ul>#{items}</ul>"} 
  end

  def show(conv, %{"id" => id}) do
    shark = Wildthings.get_shark(id) 
    %{conv | status: 200, resp_body: "Shark - #{shark.name}"}
  end

  def create(conv) do 
    %{ conv | status: 201, 
              resp_body: "Created a #{conv.params["name"]} #{conv.params["type"]} shark"} 
  end  
end 

