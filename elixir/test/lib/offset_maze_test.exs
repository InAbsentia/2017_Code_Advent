defmodule Advent.OffsetMazeTest do
  use ExUnit.Case, async: true

  alias Advent.OffsetMaze

  @input "test/support/offset_list.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)

  describe "without decrement" do
    test "example" do
      assert OffsetMaze.step_count([0, 3, 0, 1, -3]) == 5
    end

    @tag slow: true
    test "real input" do
      assert OffsetMaze.step_count(@input) == 326618
    end
  end

  describe "decrementing above 3" do
    test "example" do
      assert OffsetMaze.step_count([0, 3, 0, 1, -3], 3) == 10
    end

    @tag slow: true, timeout: 100_000
    test "real input" do
      assert OffsetMaze.step_count(@input, 3) == 21841249
    end
  end
end
