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
  Signal the provided morse symbols using the GPIO.
  """

  def signal do
    code = secret_code()
    code_length = length(code)

    update_progress(0, code_length)

    {:ok, gpio} = GPIO.open(relay_pin(), :output)
    GPIO.write(gpio, @off)
    Process.sleep(@sleep_start)

    code
    |> Enum.with_index()
    |> Enum.each(&signal_symbol(gpio, &1, code_length))

    update_progress(100, 100)
  end

  defp signal_symbol(gpio, {'.', _index}, _length) do
    GPIO.write(gpio, @on)
    Process.sleep(@sleep_short)
    GPIO.write(gpio, @off)
    Process.sleep(@sleep_delay)
  end

  defp signal_symbol(gpio, {'-', _index}, _length) do
    GPIO.write(gpio, @on)
    Process.sleep(@sleep_long)
    GPIO.write(gpio, @off)
    Process.sleep(@sleep_delay)
  end

  defp signal_symbol(_gpio, {' ', index}, length) do
    Process.sleep(@sleep_pause)
    update_progress(index, length)
  end

  defp signal_symbol(_gpio, {symbol, _index}, _length) do
    {:error, "Undefined symbol: " <> <<symbol :: utf8>>}
  end

  defp update_progress(index, length) do
    Morse.Server.update_progress(index / length * 100)
  end

  defp relay_pin() do
    Application.fetch_env!(:morse, :relay_pin)
  end

  defp secret_code do
    Application.fetch_env!(:morse, :morse_message)
    |> String.to_charlist()
  end
end
