defmodule Advent.Checksum do
  def min_max(input) when is_list(input) do
    input
    |> Stream.map(fn(row) -> Enum.max(row) - Enum.min(row) end)
    |> Enum.sum
  end
  def min_max(_), do: {:error, "invalid input"}

  def div(input) when is_list(input) do
    Enum.reduce(input, 0, fn(row, sum) ->
      row
      |> Enum.reduce(0, fn(n, acc) ->
        if x = Enum.find(row, &(n != &1 and rem(n, &1) == 0)),
          do: acc + div(n, x),
          else: acc
      end)
      |> Kernel.+(sum)
    end)
  end
  def div(_), do: {:error, "invalid input"}
end
