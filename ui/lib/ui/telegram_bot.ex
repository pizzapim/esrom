defmodule Ui.TelegramBot do
  def message(msg) do
    Telegram.Api.request(token(), "sendMessage", chat_id: chat_id(), text: msg)
  end

  defp chat_id do
    Application.fetch_env!(:ui, :chat_id)
  end

  defp token do
    Application.fetch_env!(:ui, :token)
  end
end
