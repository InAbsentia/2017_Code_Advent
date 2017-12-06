defmodule Advent.SpiralTest do
  use ExUnit.Case, async: true

  alias Advent.Spiral

  @input 368078

  describe "finding cell distance" do
    test "cell 1" do
      assert Spiral.distance(1) == 0
    end

    test "cell 12" do
      assert Spiral.distance(12) == 3
    end

    test "cell 23" do
      assert Spiral.distance(23) == 2
    end

    test "cell 1024" do
      assert Spiral.distance(1024) == 31
    end

    test "real input" do
      assert Spiral.distance(@input) == 371
    end
  end

  describe "finding next largest sum" do
    test "1" do
      assert Spiral.next_sum(1) == 2
    end

    test "2" do
      assert Spiral.next_sum(2) == 4
    end

    test "25" do
      assert Spiral.next_sum(25) == 26
    end

    test "133" do
      assert Spiral.next_sum(133) == 142
    end

    test "362" do
      assert Spiral.next_sum(362) == 747
    end

    test "real input" do
      assert Spiral.next_sum(@input) == 369601
    end
  end
end
