defmodule UiWeb.PageController do
  use UiWeb, :controller

  def index(conn, _params) do
    conn |> send_resp(204, "")
  end

  def instructions(conn, _params) do
    conn |> render(:instructions)
  end

  def morse(conn, _params) do
    conn |> render(:morse)
  end

  def start(conn, _params) do
    response =
      case Morse.Server.start_morse() do
        :ok -> "Started."
        {:error, :already_started} -> "The process is still in progress..."
      end

    conn |> text(response)
  end
end
