defmodule Prediction do
  @moduledoc """
  This modules holds functions that take a number
  and a range and proceeds to do a number of gueses to find
  the number in the range
  """
  def guess(number, range, guess \\ 0)

  def guess(a, b..c, g) when g == a do
    # if g is equal to 0
    # print answer
    IO.puts "#{a}"
  end

  def guess(a,b..c, g) when g > a do
    # if g is larger than a then
    # call guess with median of b to g -1
    new_top = g - 1
    new_total = b + new_top
    current_guess = div(new_total,2)
    IO.puts "Is it #{current_guess}"
    guess(a, b..new_top, current_guess)
  end

  def guess(a,b..c, g) when g < a do
    # if g is smaller than a
    # call guess with a median of c to g + 1
    new_bottom = g + 1
    new_total = c + new_bottom
    current_guess = div(new_total, 2)
    IO.puts "Is it #{current_guess}"
    guess(a, new_bottom..c, current_guess)
  end
end 
