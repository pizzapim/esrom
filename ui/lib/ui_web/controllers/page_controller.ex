defmodule UiWeb.PageController do
  use UiWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    send_resp(conn, 204, "")
  end

  def instructions(conn, _params) do
    render(conn, :instructions)
  end

  def morse(conn, _params) do
    ip = case Plug.Conn.get_req_header(conn, "x-real-ip") do
      [h|_tl] -> h
      _ -> "0.0.0.0"
    end
    LiveView.Controller.live_render(conn, UiWeb.MorseLive, session: %{ip: ip})
  end
end
