defmodule Ui.SocketAPI do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:broadcast_progress, progress}, state) do
    UiWeb.Endpoint.broadcast("morse:progress", "update", %{value: progress})
    {:noreply, state}
  end
end
