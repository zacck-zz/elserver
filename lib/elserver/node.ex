defmodule Elserver.Node do 
  @doc"""
  Simulates sending a request to an external api 
  to get some data bacl 
  """

  def get_data(node_id) do
    # Send request 
    # Wait for request to complete 
    :timer.sleep(2000)
    # Return response
    "#{:rand.uniform(1000)}-data"
  end 
end 
