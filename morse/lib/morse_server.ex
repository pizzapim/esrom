defmodule MorseServer do
  use GenServer
  use Application

  @impl true
  def start(_type, _args) do
    start_link()
  end

  def start_link do
    GenServer.start_link(__MODULE__, :off, name: __MODULE__)
  end

  def start_morse do
    GenServer.call(__MODULE__, :start)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:start, _from, :on) do
    {:reply, {:error, :already_started}, :on}
  end

  def handle_call(:start, _from, :off) do
    spawn(MorseSignaler, :signal, [self()])
    {:reply, :ok, :on}
  end

  @impl true
  def handle_cast(:done, :on) do
    {:noreply, :off}
  end
end
