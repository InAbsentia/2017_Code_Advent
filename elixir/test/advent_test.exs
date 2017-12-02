defmodule AdventTest do
  use ExUnit.Case

  alias Advent.Captcha

  test "day one solves captchas" do
    assert Advent.day_one(1225, :next) == Captcha.solve(1225, :next)
    assert Advent.day_one(1215, :half) == Captcha.solve(1215, :half)
  end
end
