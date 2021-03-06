defmodule Morse.Worker do
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

    update_progress(0, 100)

    toggle_lamp(@off)
    Process.sleep(@sleep_start)

    code
    |> Enum.with_index()
    |> Enum.each(&signal_symbol(&1, code_length))

    update_progress(100, 100)
  end

  def kill(pid) do
    Process.exit(pid, :kill)
    toggle_lamp(@off)
  end

  defp signal_symbol({?., _index}, _length) do
    toggle_lamp(@on)
    Process.sleep(@sleep_short)
    toggle_lamp(@off)
    Process.sleep(@sleep_delay)
  end

  defp signal_symbol({?-, _index}, _length) do
    toggle_lamp(@on)
    Process.sleep(@sleep_long)
    toggle_lamp(@off)
    Process.sleep(@sleep_delay)
  end

  defp signal_symbol({?\s, index}, length) do
    update_progress(index, length)
    Process.sleep(@sleep_pause)
  end

  defp update_progress(index, length) do
    Morse.Server.update_progress(index / length * 100)
  end

  defp secret_code do
    Application.fetch_env!(:morse, :morse_message)
    |> String.to_charlist()
  end

  # Communicate with a deployed esrom node, if running on a host.
  case Application.get_env(:ui, :target) do
    :host ->
      @esrom_node :"esrom@esrom.lan"

      def toggle_lamp(state) do
        # Check if the deployed esrom node is online.
        if :pong == Node.ping(@esrom_node) do
          :rpc.call(@esrom_node, Morse.Worker, :toggle_lamp, [state])
        end
      end

    _ ->
      def toggle_lamp(state) do
        {:ok, gpio} = Circuits.GPIO.open(relay_pin(), :output)
        Circuits.GPIO.write(gpio, state)
      end

      defp relay_pin() do
        Application.fetch_env!(:morse, :relay_pin)
      end
  end
end
