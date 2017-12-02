defmodule Advent.Captcha do
  defmodule Data do
    defstruct numbers: [], length: 0, offset: 1
  end

  def solve(nums, :next) when is_list(nums),
    do: nums |> extract_matching(1) |> Enum.sum
  def solve(nums, :half) when is_list(nums),
    do: nums |> extract_matching(round(length(nums) / 2)) |> Enum.sum
  def solve(n, type) when is_integer(n), do: n |> Integer.digits |> solve(type)
  def solve(_, _), do: {:error, "invalid input"}

  defp extract_matching(nums, offset) do
    extract_matching(
      %Data{numbers: nums, length: length(nums), offset: offset}, 0, [])
  end
  defp extract_matching(data = %{length: l}, index, matches)
  when index < l do
    n = Enum.at(data.numbers, index)
    matches = if n == Enum.at(data.numbers, next(data, index)),
      do: [n | matches],
      else: matches
    extract_matching(data, index + 1, matches)
  end
  defp extract_matching(%{length: l}, index, matches)
  when l == index, do: matches

  defp next(%{length: length, offset: offset}, index)
  when index + offset < length, do: index + offset
  defp next(%{length: length, offset: offset}, index),
    do: offset - (length - index)
end
