defmodule Morse.Server do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, {nil, 0}, name: __MODULE__)
  end

  def start_morse do
    GenServer.call(__MODULE__, :start)
  end

  def update_progress(progress) do
    GenServer.cast(__MODULE__, {:progress, progress})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:start, _from, {pid, _progress} = state) do
    if pid == nil or not Process.alive?(pid) do
      pid = spawn(&Morse.Worker.signal/0)
      {:reply, :ok, {pid, 0}}
    else
      {:reply, {:error, :already_started}, state}
    end
  end

  @impl true
  def handle_cast({:progress, new_progress}, {pid, _progress}) do
    GenServer.cast(Ui.SocketAPI, {:broadcast_progress, new_progress})
    {:noreply, {pid, new_progress}}
  end
end
