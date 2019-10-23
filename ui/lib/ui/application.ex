defmodule Ui.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      UiWeb.Endpoint
      # Starts a worker by calling: Ui.Worker.start_link(arg)
      # {Ui.Worker, arg},
    ] ++ children(target())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ui.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def children(:host) do
    {:ok, _} = Node.start(:"host@0.0.0.0")
    Node.set_cookie(:tastycookie)
    true = Node.connect(:"esrom@esrom.lan")
    []
  end

  def children(_target), do: []

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UiWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def target() do
    Application.get_env(:ui, :target)
  end
end
