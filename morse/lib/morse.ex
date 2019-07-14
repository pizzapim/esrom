defmodule Morse do
  @moduledoc """
  Functions to control the signal lamp connected with GPIO.
  """

  @doc """
  Takes a string composed of dots and dashes, and signals them with the
  signal lamp.
  """
  def signal(msg) do
    IO.puts(msg)
  end
end
