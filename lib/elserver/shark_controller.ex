defmodule Elserver.SharkController do 
  alias Elserver.Wildthings
  
  @templates_path Path.expand("templates", File.cwd!)

  defp render(conv, template, bindings \\ []) do 
    content = 
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)
    %{conv| status: 200, resp_body: content} 
  end 

  def index(conv) do
    items = 
      Wildthings.list_sharks()
    render(conv, "index.eex", sharks: items)
  end

  def show(conv, %{"id" => id}) do
    shark = Wildthings.get_shark(id) 
    render(conv, "show.eex", shark: shark)
  end

  def create(conv) do 
    %{ conv | status: 201, 
              resp_body: "Created a #{conv.params["name"]} #{conv.params["type"]} shark"} 
  end

  def delete(conv, %{"id" => id}) do 
   %{conv | status: 202, resp_body: "Deleting #{id} ..."}
  end  
end  

