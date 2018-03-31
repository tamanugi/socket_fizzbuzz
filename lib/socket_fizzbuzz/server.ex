defmodule SocketFizzbuzz.Server do

  alias SocketFizzbuzz.Fizzbuzz

  def start_link(port \\ 9000) do

    Fizzbuzz.start_link

    server = Socket.Web.listen! port

    loop(server)
  end 

  def loop(server) do

    client = server |> Socket.Web.accept!
    client |> Socket.Web.accept!

     Task.async(fn -> recv(client) end)
  
    loop(server)
  end

  def recv(client) do
    # クライアントからのメッセージをハンドリング
    case client |> Socket.Web.recv! do
      {:text, message} -> 
        text = fizzbuzz(client, message) |> Integer.to_string
        Socket.Web.send!(client, {:text, text})
        recv(client)

      {:close, _, _} ->
         Fizzbuzz.reset(client)

      other -> Io.inspect other
    end
  end

  def fizzbuzz(client, message) do
    case Fizzbuzz.check?(client, message) do
      true -> Fizzbuzz.next(client)
      false -> 
        Fizzbuzz.reset(client)
        -1
    end
  end
end