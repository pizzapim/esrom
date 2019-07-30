defmodule UiWeb.MorseProgressChannel do
  use UiWeb, :channel

  def join(_channel_name, _params, socket) do
    {:ok, %{hi: :there}, socket}
  end
end
