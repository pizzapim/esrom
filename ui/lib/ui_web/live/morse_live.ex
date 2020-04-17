defmodule UiWeb.MorseLive do
  use Phoenix.LiveView
  require Logger

  @topic "morse_progress"

  def render(assigns) do
    UiWeb.PageView.render("morse.html", assigns)
  end

  def mount(%{ip: ip}, socket) do
    UiWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, default_assigns(ip))}
  end

  def handle_event("toggle_morse", _value, %{assigns: %{ip: ip}} = socket) do
    Logger.info("#{ip} pressed the button!")

    if not Morse.Server.in_progress?() and ip_send_message?(ip) do
      Logger.info("Sending Telegram message.")
      spawn(fn -> Ui.TelegramBot.message("#{ip} pressed the button!") end)
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

  defp ip_send_message?(ip) do
    not (String.starts_with?(ip, "192.168.") or String.starts_with?(ip, "10.")
      or ip == "127.0.0.1" or ip == "localhost" or ip == "0.0.0.0")
  end
end
