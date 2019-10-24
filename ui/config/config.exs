use Mix.Config

config :ui, target: Mix.target()

config :ui, UiWeb.Endpoint,
  live_view: [signing_salt: "h4niP0Ovx/wDHjKRBJelcKHsbBUzptcagimD/iSDHMg5r535/A1ad5uAKJjY9ktI"],
  pubsub: [name: Ui.PubSub, adapter: Phoenix.PubSub.PG2]

config :phoenix, :json_library, Jason
config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

config :morse, :pubsub, Phoenix.PubSub

if Mix.target() != :host do
  "target.exs"
else
  "host.exs"
end
|> import_config()

if File.exists?("config/secrets.exs") do
  import_config "secrets.exs"
end
