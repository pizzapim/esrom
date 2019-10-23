defmodule UiWeb.MorseLive do
  use Phoenix.LiveView

  @topic "morse_progress"

  def render(assigns) do
    UiWeb.PageView.render("morse.html", assigns)
  end

  def mount(_session, socket) do
    UiWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, progress: Morse.Server.progress())}
  end

  def handle_event("start_morse", _value, socket) do
    Morse.Server.start_morse()
    {:noreply, socket}
  end

  def handle_info(progress, socket) do
    {:noreply, assign(socket, progress: progress)}
  end
end
