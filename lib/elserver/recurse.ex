defmodule Recurse do
  @moduledoc ~S"""
  Runs a few recursive function examples
  """

  def sum([h|t], total) do 

    total = h + total 

    sum(t, total)
  end 

  def sum([],total), do: total

  def triple([h|t], triples) do
    tripled = h * 3 
    triples = triples ++ [tripled]
    triple(t, triples)
  end 

  def triple([], triples), do: triples
end 


IO.puts inspect Recurse.sum([1,2,3,4,5], 0) 

IO.puts inspect Recurse.triple([1,2,3,4,5,6], [])
