defmodule Morse.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Morse.Server, nil}
    ]

    opts = [strategy: :one_for_one, name: Morse.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
