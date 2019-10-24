defmodule UiWeb.PageController do
  use UiWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    send_resp(conn, 204, "")
  end

  def instructions(conn, _params) do
    render(conn, :instructions)
  end

  def morse(%{remote_ip: ip} = conn, _params) do
    ip = ip |> Tuple.to_list |> Enum.join(".")
    LiveView.Controller.live_render(conn, UiWeb.MorseLive, session: %{ip: ip})
  end
end
