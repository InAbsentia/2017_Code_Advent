defmodule Advent.Spiral do
  @neighbors [
    {-1,  1}, {0,  1}, {1,  1},
    {-1,  0},          {1,  0},
    {-1, -1}, {0, -1}, {1, -1}]

  def distance(n) when is_integer(n) do
    k = ((:math.sqrt(n) - 1) / 2) |> Float.ceil |> round
    t = 2 * k + 1
    m = t * t
    t = t - 1

    {x, y} = find_cell(n, m, t, k, 1)

    abs(x) + abs(y)
  end
  def distance(_), do: {:error, "invalid input"}

  def next_sum(n) when is_integer(n) do
    {0, 0}
    |> Stream.iterate(&next_cell/1)
    |> Stream.transform(%{}, &calculate_value/2)
    |> Enum.find(&(&1 > n))
  end
  def next_sum(_), do: {:error, "invalid input"}

  defp find_cell(n, m, t, k, 1) when n >= m - t, do: {k - (m - n), -k}
  defp find_cell(n, m, t, k, 2) when n >= m - t, do: {-k, -k + (m - n)}
  defp find_cell(n, m, t, k, 3) when n >= m - t, do: {-k + (m - n), k}
  defp find_cell(n, m, t, k, 3), do: {k, k - (m - n - t)}
  defp find_cell(n, m, t, k, i), do: find_cell(n, m - t, t, k, i + 1)

  defp next_cell({x, y})
  when abs(x) <= abs(y) and (x != y or x >= 0) do
    dx = if y >= 0, do: 1, else: -1
    {x + dx, y}
  end
  defp next_cell({x, y}) do
    dy = if x >= 0, do: -1, else: 1
    {x, y + dy}
  end

  defp calculate_value({0, 0}, grid), do: {[1], Map.put(grid, {0, 0}, 1)}
  defp calculate_value(cell, grid) do
    value = sum_neighbors(grid, cell)
    {[value], Map.put(grid, cell, value)}
  end

  defp sum_neighbors(grid, {x, y}) do
    @neighbors
    |> Stream.map(fn({x_offset, y_offset}) ->
      Map.get(grid, {x + x_offset, y + y_offset}, 0)
    end)
    |> Enum.sum
  end
end
