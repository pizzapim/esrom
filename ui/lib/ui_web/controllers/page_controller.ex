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
    ip = conn |> Plug.Conn.get_req_header("x-real-ip") |> hd()
    LiveView.Controller.live_render(conn, UiWeb.MorseLive, session: %{ip: ip})
  end
end
