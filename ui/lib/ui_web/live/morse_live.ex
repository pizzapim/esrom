defmodule UiWeb.MorseLive do
  use Phoenix.LiveView

  @topic "morse_progress"

  def render(assigns) do
    UiWeb.PageView.render("morse.html", assigns)
  end

  def mount(_session, socket) do
    UiWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, default_assigns())}
  end

  def handle_event("start_morse", _value, socket) do
    Morse.Server.start_morse()
    {:noreply, socket}
  end

  def handle_event("toggle_hint", _value, socket) do
    {:noreply, update(socket, :hints_visible, &(not &1))}
  end

  def handle_info(progress, socket) do
    {:noreply, assign(socket, progress: progress, in_progress?: Morse.Server.in_progress?())}
  end

  defp default_assigns do
    [
      progress: Morse.Server.progress(),
      in_progress?: Morse.Server.in_progress?(),
      hints_visible: false
    ]
  end
end
