defmodule Elserver.PledgeController do 
  def create(conv, %{"name" =>  name, "amount" =>  amount}) do
    #send pledge to persistenent
    create_pledge(name, String.to_integer(amount))

    %{ conv  | status: 201, resp_body: "Thank you #{name} for pledging #{amount}" }
  end

  def index(conv) do
    #get some recent pledges from cache
    pledges = recent_pledges 
    %{ conv | status: 200, resp_body: (inspect pledges)}
  end 
end 
