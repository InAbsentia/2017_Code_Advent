defmodule Advent.TowerTest do
  use ExUnit.Case, async: true

  alias Advent.Tower

  @example [
    {"pbga", {66, []}}, {"xhth", {57, []}}, {"ebii", {61, []}},
    {"havc", {66, []}}, {"ktlj", {57, []}},
    {"fwft", {72, ["ktlj", "cntj", "xhth"]}}, {"qoyq", {66, []}},
    {"padx", {45, ["pbga", "havc", "qoyq"]}},
    {"tknk", {41, ["ugml", "padx", "fwft"]}}, {"jptl", {61, []}},
    {"ugml", {68, ["gyxo", "ebii", "jptl"]}}, {"gyxo", {61, []}},
    {"cntj", {57, []}}]

  @input "test/support/program_tower.txt"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.map(fn(program) ->
    matches = Regex.named_captures(
      ~r/^(?<name>\w+) \((?<weight>\d+)\)( -> (?<children>[\w, ]+))?/, program)
    {matches["name"],
     {String.to_integer(matches["weight"]),
      String.split(matches["children"], ", ", trim: true)}}
  end)

  describe "finding the root" do
    test "example" do
      assert Tower.root(@example) |> elem(0) == "tknk"
    end

    test "real input" do
      assert Tower.root(@input) |> elem(0) == "ahnofa"
    end
  end

  describe "unbalanced" do
    test "example" do
      assert Tower.rebalance(@example) == {"ugml", 60}
    end

    test "real input" do
      assert Tower.rebalance(@input) == {"ltleg", 802}
    end
  end
end
