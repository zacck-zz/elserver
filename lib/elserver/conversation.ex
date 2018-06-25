defmodule Elserver.Conversation do
  @moduledoc """
  This module contains the structure for our Conversation object
  It enables us to serialize informations into a Conversation and 
  also enables use to deserialize a Conversation into information 
  """
  
  # build a struct 
  defstruct method: "", 
            path: "", 
            params: %{},
            headers: %{},
            resp_body: "", 
            status: nil,
            resp_headers: %{"Content-Type" => "text/html"}
  
  @doc"""
  This function takes a conversation and returns the full 
  reason containing code and the status
  """
  def full_status(conv) do 
    "#{conv.status} #{status_reason(conv.status)}"
  end 
  
  @doc"""
  This function calculates the size of the response body 
  """
  def content_length(conv) do 
    byte_size(conv.resp_body)
  end

  # define a private function using defp codes 
  defp status_reason(code) do 
    %{
      200 => "OK",
      201 => "Created",
      202 => "Accepted",
      204 => "No Content",
      401 => "Unauthorized",
      403 => "Forbidden", 
      404 => "Not Found",
      500 => "Internal Server Error", 
    }[code]
  end 


end 
