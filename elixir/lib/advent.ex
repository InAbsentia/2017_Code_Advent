defmodule Advent do
  @moduledoc """
  Top-level API for Advent of Code problems.
  """

  alias Advent.Captcha

  def day_one(input, type), do: Captcha.solve(input, type)
end
