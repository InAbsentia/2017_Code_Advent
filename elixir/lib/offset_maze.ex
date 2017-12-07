defmodule Advent.OffsetMaze do
  def step_count(offsets) when is_list(offsets), do: count_steps(offsets)
  def step_count(_), do: {:error, "invalid input"}
  def step_count(offsets, decrement_above) when is_list(offsets),
    do: count_steps(offsets, &increment(&1, decrement_above))
  def step_count(_, _), do: {:error, "invalid input"}

  defp count_steps(offsets, incrementer \\ &(&1 + 1)) do
    finish = length(offsets)

    offsets =
      offsets
      |> Stream.with_index
      |> Enum.into(%{}, fn ({val, i}) -> {i, val} end)

    Stream.iterate({offsets, 0}, fn({data, index}) ->
      {Map.update!(data, index, incrementer), index + data[index]}
    end)
    |> Enum.take_while(fn({_, index}) -> finish > index end)
    |> length
  end

  defp increment(value, decrement_above)
  when decrement_above > value, do: value + 1
  defp increment(value, _), do: value - 1
end
