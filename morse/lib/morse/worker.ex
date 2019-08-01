defmodule Morse.Worker do
  alias Circuits.GPIO

  @moduledoc """
  Functions to control the signal lamp connected with GPIO.
  """

  @sleep_short 200
  @sleep_delay 400
  @sleep_long 700
  @sleep_pause 1000
  @sleep_start 3000

  @on 0
  @off 1

  @doc """
  Signal the provided symbols using GPIO.
  Notifies the parent when the signalling is done.
  """

  def signal() do
    {:ok, gpio} = GPIO.open(relay_pin(), :output)
    GPIO.write(gpio, @off)
    Process.sleep(@sleep_start)
    update_progress(gpio, String.graphemes(secret_code()))
  end

  # Update progress for clients, and signals the rest of the sentence.
  defp update_progress(gpio, symbols) do
    100 - length(symbols) / String.length(secret_code()) * 100
    |> Morse.Server.update_progress()
    if symbols != [] do
      signal_sentence(gpio, symbols)
    end
  end

  # Signal a whole sentence of symbols with GPIO.
  defp signal_sentence(gpio, []) do
    GPIO.write(gpio, @off)
    GPIO.close(gpio)
    update_progress(gpio, [])
    :ok
  end

  defp signal_sentence(gpio, [symbol | rest]) when symbol in [".", "-"] do
    GPIO.write(gpio, @on)

    case symbol do
      "." -> Process.sleep(@sleep_short)
      "-" -> Process.sleep(@sleep_long)
    end

    GPIO.write(gpio, @off)

    Process.sleep(@sleep_delay)
    signal_sentence(gpio, rest)
  end

  defp signal_sentence(gpio, [" " | rest]) do
    Process.sleep(@sleep_pause)

    update_progress(gpio, rest)
  end

  defp signal_sentence(_gpio, [symbol | _rest]) do
    {:error, "Undefined symbol: " <> symbol}
  end

  defp relay_pin() do
    Application.fetch_env!(:morse, :relay_pin)
  end

  defp secret_code do
    Application.fetch_env!(:morse, :morse_message)
  end
end
