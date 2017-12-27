defmodule Advent.RegistersTest do
  use ExUnit.Case, asyc: true

  alias Advent.Registers

  @example [
    %{register: "b", operation: "inc", amount: 5, condition: "a > 1"},
    %{register: "a", operation: "inc", amount: 1, condition: "b < 5"},
    %{register: "c", operation: "dec", amount: -10, condition: "a >= 1"},
    %{register: "c", operation: "inc", amount: -20, condition: "c == 10"}]

  @input "test/support/register_ops.txt"
  |> File.stream!
  |> Enum.map(fn line ->
    [operation, condition] = line |> String.trim |> String.split(" if ")
    [reg, op, amount] = String.split(operation)
    %{register: reg,
      operation: op,
      amount: String.to_integer(amount),
      condition: condition}
  end)

  describe "largest register value" do
    test "for example" do
      assert Registers.largest(@example) == 1
    end

    test "for input" do
      assert Registers.largest(@input) == 5215
    end
  end

  describe "largest ever register value" do
    test "for example" do
      assert Registers.highest_value(@example) == 10
    end

    test "for input" do
      assert Registers.highest_value(@input) == 6419
    end
  end
end
