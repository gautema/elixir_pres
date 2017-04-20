defmodule MyGenServer do
  use GenServer

  #Api
  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  def create(server, name, value) do
    GenServer.cast(server, {:create, [name, value]})
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_cast({:create, [name, value]}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:noreply, Map.put(names, name, value)}
    end
  end
end

 {:ok, server} = MyGenServer.start_link
 MyGenServer.create(server, "name", "Gaute")
 MyGenServer.lookup(server,"name") 
