defmodule MorseServer do
  use GenServer
  use Application

  @impl true
  def start(_type, _args) do
    start_link()
  end

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_morse do
    GenServer.call(__MODULE__, :start)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:start, _from, pid) do
    cond do
      pid == nil or not Process.alive?(pid) ->
        pid = spawn(&MorseSignaler.signal/0)
        {:reply, :ok, pid}

      true ->
        {:reply, {:error, :already_started}, pid}
    end
  end
end
