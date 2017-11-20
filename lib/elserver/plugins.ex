defmodule Elserver.Plugins do 
  @moduledoc """
  Provides some plugins to use
  """
  alias Elserver.Conversation
  alias Elserver.FourOhFourCounter 



  @doc "Logs any 404 responses the server shows"
  def track(%Conversation{status: 404, path: path} = conv) do 
    #FourOhFourCounter.bump_count(path)
    conv
  end 

  @doc "Returns unmodified convos"
  def track(%Conversation{} =  conv), do: conv

  # path rewrites 
  def rewrite_path(%Conversation{path: "/wildlife"} = conv) do 
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conversation{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path) 
    rewrite_path_captures(conv, captures)
  end 
  
  def rewrite_path(%Conversation{} = conv), do: conv

  # emojify response 
  def emojify(%Conversation{status: 200 } = conv) do
    %{conv | resp_body: "😎#{conv.resp_body}😎"}
  end 

  def emojify(%Conversation{} = conv), do: conv

  # use path captures in path 
  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    log(conv) 
    %{conv | path: "/#{thing}/#{id}"}
  end 

  def rewrite_path_captures(conv, nil), do: conv 
  
  # Inspect
  def log(conv) do
    if Mix.env == :dev do
      IO.inspect conv
    end 
  end
end 


