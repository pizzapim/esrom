defmodule UiWeb.MorseLive do
  use Phoenix.LiveView

  @topic "morse_progress"

  def render(assigns) do
    UiWeb.PageView.render("morse.html", assigns)
  end

  def mount(%{ip: ip}, socket) do
    UiWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, default_assigns(ip))}
  end

  def handle_event("toggle_morse", _value, %{assigns: %{ip: ip}} = socket) do
    if Morse.Server.in_progress?() do
      spawn fn -> Ui.TelegramBot.message("#{ip} pressed the button!") end
    end
    Morse.Server.toggle_morse()

    {:noreply, socket}
  end

  def handle_event("toggle_hint", _value, socket) do
    {:noreply, update(socket, :hints_visible, &(not &1))}
  end

  def handle_info(progress, socket) do
    {:noreply, assign(socket, progress: progress, in_progress?: Morse.Server.in_progress?())}
  end

  defp default_assigns(ip) do
    [
      progress: Morse.Server.progress(),
      in_progress?: Morse.Server.in_progress?(),
      hints_visible: false,
      ip: ip
    ]
  end
end
