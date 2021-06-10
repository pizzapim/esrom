defmodule Ui.MessageBot do
  def message(msg) do
    {:ok, _result} = Tesla.put(client(), "/_matrix/client/r0/rooms/" <> room() <> "/send/m.room.message/" <> transaction_id(), construct_message(msg))
  end

  def client do
    middleware = [
      {Tesla.Middleware.BaseUrl, matrix_ip()},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Host", matrix_host()}, {"Authorization", "Bearer " <> token()}]}
    ]

    Tesla.client(middleware)
  end

  def token do
    Application.fetch_env!(:ui, :matrix_token)
  end

  def matrix_ip do
    Application.fetch_env!(:ui, :matrix_ip)
  end

  def matrix_host do
    Application.fetch_env!(:ui, :matrix_host)
  end

  def room do
    Application.fetch_env!(:ui, :matrix_room)
  end

  def transaction_id do
    id = DateTime.utc_now()
         |> DateTime.to_unix()
         |> Integer.to_string()

    "esrom-" <> id
  end

  def construct_message(msg) do
    %{msgtype: "m.text", body: msg}
  end
end
