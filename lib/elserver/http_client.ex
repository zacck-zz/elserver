defmodule Elserver.HttpClient do
  @doc"""
  Starts a http client
  """
  def send(port, request) do
    localhost = 'localhost' # to make it runnable on one machine
    {:ok, socket} = 
      :gen_tcp.connect(localhost, port, [:binary, packet: :raw, active: false])
    IO.puts "-> Http Client to #{localhost} at port #{port} started"
    :ok = :gen_tcp.send(socket, request)
    IO.puts "Sending request to #{localhost}"
    {:ok, response} =  :gen_tcp.recv(socket, 0)
    IO.puts response
    :ok = :gen_tcp.close(socket)
    IO.puts "Closing socket"
  end 

end


request = """
GET /sharks HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""


