# esrom
Source code for [the esrom geocache](https://www.geocaching.com/geocache/GC7C642_esrom).

If you have found the source code before finding the geocache, consider it a hint :)

## Setup (for future me)
- elixir 1.9.0-otp-22
- erlang 22.0.4
- nodejs 12.6.0
- [Nerves](https://hexdocs.pm/nerves/installation.html)
- [Phoenix](https://hexdocs.pm/phoenix/installation.html)

Building:
```bash
cd ui/assets && npm install
cd ../ && mix phx.digest
cd ../firmware && mix deps.get
mix firmware
mix firmware.burn # After inserting SD card
```

## Setting morse code
Still have to find out how to correctly set secrets... so I have to do it manually now.

```bash
ssh nerves.local
```

```elixir
System.set_env("MORSE_MESSAGE", "...---...")
```
