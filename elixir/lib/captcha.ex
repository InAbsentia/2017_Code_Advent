defmodule Advent.Captcha do
  def solve(nums) when is_list(nums), do: nums |> extract_matching |> Enum.sum
  def solve(n) when is_integer(n), do: n |> Integer.digits |> solve
  def solve(_), do: {:error, "invalid input"}

  defp extract_matching(nums = [first | _]),
    do: extract_matching(nums, first, [])
  defp extract_matching([n | rest], first, matches),
    do: extract_matching(rest, first, matches(n, rest, first, matches))
  defp extract_matching([], _, matches), do: matches

  defp matches(n, [m | _], _first, matches) when n == m, do: [n | matches]
  defp matches(n, [], first, matches) when n == first, do: [n | matches]
  defp matches(_, _, _, matches), do: matches
end
