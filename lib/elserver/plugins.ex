defmodule Elserver.Plugins do 
  @moduledoc """
  Provides some plugins to use
  """
  @doc "Logs any 404 responses the server shows"
  def track(%{status: 404, path: path} = conv) do 
    IO.puts "Warning: #{path} does not exist on this server"
    conv
  end 

  @doc "Returns unmodified convos"
  def track(conv), do: conv

  # path rewrites 
  def rewrite_path(%{path: "/wildlife"} = conv) do 
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path) 
    rewrite_path_captures(conv, captures)
  end 
  
  def rewrite_path(conv), do: conv

  # emojify response 
  def emojify(%{status: 200 } = conv) do
    %{conv | resp_body: "😎  #{conv.resp_body} 😎"}
  end 

  def emojify(conv), do: conv

  # use path captures in path 
  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    log(conv) 
    %{conv | path: "/#{thing}/#{id}"}
  end 

  def rewrite_path_captures(conv, nil), do: conv 
  
  # Inspect
  def log(conv), do: IO.inspect conv
 
end 


