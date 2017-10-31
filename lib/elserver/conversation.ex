defmodule Elserver.Conversation do
  defstruct method: "", 
            path: "", 
            params: %{},
            headers: %{},
            resp_body: "", 
            status: nil,
            resp_headers: %{"Content-Type" => "text/html"}
  
  def full_status(conv) do 
    "#{conv.status} #{status_reason(conv.status)}"
  end 

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
