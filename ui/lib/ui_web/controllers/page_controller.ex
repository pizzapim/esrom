defmodule UiWeb.PageController do
  use UiWeb, :controller

  def index(conn, _params) do
    conn
    |> send_resp(201, "")
  end

  def instructions(conn, _params) do
    conn
    |> render(:instructions)
  end

  def morse(conn, _params) do
    conn
    |> render(:morse)
  end

  def start(conn, _params) do
    now = System.system_time(:second)

    case get_start_time() do
      start_time when start_time + 35 <= now ->
        System.put_env("MORSE_START_TIME", Integer.to_string(now))
        Morse.signal()
        text(conn, "Done.")
      _ ->
        text(conn, "It is still in progress...")
    end
  end

  defp get_start_time() do
    case System.get_env("MORSE_START_TIME") do
      nil -> 0
      start_time -> String.to_integer(start_time)
    end
  end
end
