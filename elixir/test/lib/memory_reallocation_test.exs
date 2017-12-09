defmodule Advent.MemoryReallocationTest do
  use ExUnit.Case, async: true

  alias Advent.MemoryReallocation, as: RA

  @input [4, 1, 15, 12, 0, 9, 9, 5, 5, 8, 7, 3, 14, 5, 12, 3]

  describe "cycle count" do
    test "example" do
      assert RA.cycle_count([0, 2, 7, 0]) == 5
    end

    test "real input" do
      assert RA.cycle_count(@input) == 6681
    end
  end

  describe "loop size" do
    test "example" do
      assert RA.loop_size([0, 2, 7, 0]) == 4
    end

    test "real input" do
      assert RA.loop_size(@input) == 2392
    end
  end
end
