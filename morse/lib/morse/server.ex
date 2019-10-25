defmodule Morse.Server do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, {nil, 0}, name: __MODULE__)
  end

  def toggle_morse do
    GenServer.call(__MODULE__, :toggle)
  end

  def update_progress(progress) do
    GenServer.cast(__MODULE__, {:progress, progress})
  end

  def progress do
    GenServer.call(__MODULE__, :progress)
  end

  def in_progress? do
    GenServer.call(__MODULE__, :in_progress?)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:toggle, _from, {pid, _progress}) do
    if worker_alive?(pid) do
      Morse.Worker.kill(pid)
      apply(pubsub(), :broadcast, [Ui.PubSub, "morse_progress", 0])
      {:reply, :ok, {nil, 0}}
    else
      pid = spawn(&Morse.Worker.signal/0)
      {:reply, :ok, {pid, 0}}
    end
  end

  def handle_call(:progress, _from, {_pid, progress} = state) do
    {:reply, progress, state}
  end

  def handle_call(:in_progress?, _from, {pid, _progress} = state) do
    {:reply, worker_alive?(pid), state}
  end

  @impl true
  def handle_cast({:progress, new_progress}, {pid, _progress}) do
    apply(pubsub(), :broadcast, [Ui.PubSub, "morse_progress", new_progress])
    {:noreply, {pid, new_progress}}
  end

  defp pubsub do
    Application.fetch_env!(:morse, :pubsub)
  end

  defp worker_alive?(pid) do
    pid != nil and Process.alive?(pid)
  end
end
