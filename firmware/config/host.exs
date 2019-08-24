use Mix.Config

config :ui, UiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FkfuB09FEncz4aAi6hS6w5bsNast+D1P12MckXr5dlRdhtFJrKqgEhvhpTU3qzgh",
  render_errors: [view: UiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ui.PubSub, adapter: Phoenix.PubSub.PG2],
  http: [port: 4000],
  server: true,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :ui, UiWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/ui_web/{live,views}/.*(ex)$",
      ~r"lib/ui_web/templates/.*(eex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
