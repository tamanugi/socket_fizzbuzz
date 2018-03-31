defmodule SocketFizzbuzz.Fizzbuzz do

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(client) do
    Agent.get(__MODULE__, &Map.get(&1, client, 1))
  end

  def remove(client) do
    Agent.update(__MODULE__, fn list -> List.delete(list, client) end)
  end

  def next(client) do
    current = get(client)
    next = current + 1

    Agent.update(__MODULE__, &Map.put(&1, client, next))

    next
  end

  def check?(client, message) do
    current = get(client)

    expect = case {rem(current, 3), rem(current, 5)} do
      {0, 0} -> "FizzBuzz"
      {0, _} -> "Fizz"
      {_, 0} -> "Buzz"
      {_, _} -> Integer.to_string(current)
    end

    message == expect
  end

  def reset(client) do
    Agent.update(__MODULE__, fn map -> 
      {_, new_map} = Map.pop(map, client)
      new_map
    end)
  end
end