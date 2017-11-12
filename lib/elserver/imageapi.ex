defmodule Elserver.ImageApi do 
  def query(url) do
    case HTTPoison.get(url) do
      {:ok,  %HTTPoison.Response{status_code: 200, body: body}} ->
        image_url =
          body
          |> Poison.Parser.parse!()
          |> get_in(["image", "image_url"])
        {:ok, image_url}
      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        %{"message" => m} = Poison.Parser.parse! body
        {:error, m}
      {:error, %HTTPoison.Error{reason: r}} ->
        {:error, r}
    end
  end 
end
