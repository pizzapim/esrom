defmodule Ui.MessageBot do
  def message(msg) do
    {:ok, _result} = Tesla.put(client(), "/_matrix/client/r0/rooms/" <> room() <> "/send/m.room.message/" <> transaction_id(), construct_message(msg))
  end

  def client do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url()},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer " <> token()}]}
    ]

    Tesla.client(middleware)
  end

  def token do
    Application.fetch_env!(:ui, :matrix_token)
  end

  def base_url do
    Application.fetch_env!(:ui, :matrix_url)
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
