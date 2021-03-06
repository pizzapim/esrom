# esrom
Source code for [the esrom geocache](https://www.geocaching.com/geocache/GC7C642_esrom).

If you have found the source code before finding the geocache, consider it a hint :)

![built with nerves](https://nerves-project.org/images/badge/nerves-badge_100x52_black.png)

## Setup (for future me)
- elixir 1.9.0-otp-22
- erlang 22.0.4
- nodejs 12.6.0
- [Nerves](https://hexdocs.pm/nerves/installation.html)
- [Phoenix](https://hexdocs.pm/phoenix/installation.html)

## dev
- Run `epmd` in the background so it can function as a distributed system with the pi.
- Run `cd ui && mix deps.get` to install Elixir dependencies.
- Run `cd assets && npm install && cd ..` to install npm dependencies.
- Run `mix phx.server` to start the server.

## Building
```bash
cd ui/ && export SECRET_KEY_BASE="$(mix phx.gen.secret | tail -1)"
export MIX_ENV=prod && export MIX_TARGET=<device>
cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode production
cd ../ && mix phx.digest
cd ../firmware && mix deps.get
mix firmware
mix firmware.burn # After inserting SD card
```

## Setting morse code
To set the morse code, create a new file under firmware/config, called secrets.exs:
```elixir
use Mix.Config

config :morse, :morse_message, "...---..."
```
