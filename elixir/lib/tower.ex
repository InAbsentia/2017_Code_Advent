defmodule Advent.Tower do
  def root(tower) do
    Enum.find(tower, fn({name, _}) -> tower |> find_parent(name) |> is_nil end)
  end

  def rebalance(tower) do
    tower
    |> Enum.into(%{})
    |> build_tree()
    |> unbalanced_branch()
  end

  defp build_tree(tower), do: build_tree(tower, root(tower), %{})
  defp build_tree(tower, {name, {weight, children}}, tree) do
    Map.put(tree, name, %{
      weight: weight,
      children: Enum.reduce(children, %{}, &build_tree(tower, find(tower, &1), &2))})
    |> Map.update!(name, &Map.put(&1, :full_weight, full_weight(&1)))
  end

  defp full_weight(%{children: children, weight: weight}) do
    if Enum.empty?(children) do
      weight
    else
      children
      |> Stream.map(fn({_, %{full_weight: weight}}) -> weight end)
      |> Enum.sum
      |> Kernel.+(weight)
    end
  end

  defp find(tower, name),
    do: Enum.find(tower, fn({n, _}) -> name == n end)

  defp find_parent(tower, name),
    do: Enum.find(tower, fn({_, {_, children}}) -> name in children end)

  defp unbalanced?(children) do
    {{_, %{full_weight: min}}, {_, %{full_weight: max}}} = Enum.min_max_by(children, fn
      {_, %{full_weight: w}} -> w
    end)
    min != max
  end

  defp unbalanced_branch(parent) when is_map(parent),
    do: parent |> Enum.take(1) |> List.first() |> unbalanced_branch()
  defp unbalanced_branch({_, data}) do
    {{off_weight, [{name, unbalanced}]}, {normal_weight, _}} =
      data.children
      |> Enum.group_by(fn {_, %{full_weight: w}} -> w end)
      |> Enum.min_max_by(fn {_, children} -> length(children) end)

    if unbalanced?(unbalanced.children) do
      unbalanced_branch(unbalanced.children)
    else
      {name, unbalanced.weight + (normal_weight - off_weight)}
    end
  end
end
