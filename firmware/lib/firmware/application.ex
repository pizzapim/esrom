defmodule Firmware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    children =
      [
        # Children for all targets
        # Starts a worker by calling: Firmware.Worker.start_link(arg)
        # {Firmware.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    {:ok, _} = Node.start(:"host@0.0.0.0")
    Node.set_cookie(:testcookie)
    true = Node.connect(:"esrom@esrom.lan")
    []
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:firmware, :target)
  end
end
