defmodule Logger do
  defmacro log(msg) do
    if Application.get_env(:logger, :enabled) do
      quote do
        IO.puts("Logged messahed: #{unquote(msg)}")
      end 
    end 
  end

  defmodule Example do
    require Logger 

    def test do
      Logger.log("This is a log message")
    end 
  end 

