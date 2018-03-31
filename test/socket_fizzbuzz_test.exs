defmodule SocketFizzbuzzTest do
  use ExUnit.Case
  doctest SocketFizzbuzz

  test "greets the world" do
    assert SocketFizzbuzz.hello() == :world
  end
end
