defmodule MorseSignaler do
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

  def signal(server_pid) do
    # {:ok, gpio} = GPIO.open(relay_pin(), :output)
    # GPIO.write(gpio, @off)
    Process.sleep(@sleep_start)
    # signal_sentence(gpio, String.graphemes(secret_code()))

    GenServer.cast(server_pid, :done)
    :ok
  end

  # Signal a whole sentence of symbols with GPIO.
  defp signal_sentence(gpio, []) do
    GPIO.write(gpio, @off)
    GPIO.close(gpio)
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

    signal_sentence(gpio, rest)
  end

  defp signal_sentence(_gpio, [symbol | _rest]) do
    {:error, "Undefined symbol: " <> symbol}
  end

  defp relay_pin() do
    Application.fetch_env!(:morse, :relay_pin)
  end

  defp secret_code do
    signal(Application.fetch_env!(:morse, :morse_message))
  end
end
