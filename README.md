# esrom
Source code for [the esrom geocache](https://www.geocaching.com/geocache/GC7C642_esrom).

If you have found the source code before finding the geocache, consider it a hint :)

## Setup (for future me)
- elixir 1.9.0-otp-22
- erlang 22.0.4
- nodejs 12.6.0
- [Nerves](https://hexdocs.pm/nerves/installation.html)
- [Phoenix](https://hexdocs.pm/phoenix/installation.html)

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
