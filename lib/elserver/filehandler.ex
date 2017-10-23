defmodule Elserver.FileHandler do 
  def handle_file({:ok, content}, conv) do 
    %{conv | status: 200, resp_body: content}
  end 

  def handle_file({:error, :enoent}, conv) do 
    %{conv | status: 404, resp_body: "The file #{conv.path} does not exist"}
  end 

  def handle_file({:error, reason}, conv) do 
    %{conv | status: 500, resp_body: "File Errror: #{reason}"}
  end 


end
