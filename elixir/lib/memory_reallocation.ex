defmodule Advent.MemoryReallocation do
  defmodule State do
    defstruct banks: [], length: 0, cycles: MapSet.new(), count: 0, seen?: false

    def new(banks) do
      %__MODULE__{
        banks: banks,
        length: Enum.count(banks),
        cycles: MapSet.new([banks])}
    end

    def update(%{count: count} = state, banks, cycles) do
      %{state |
        banks: banks,
        cycles: MapSet.put(cycles, banks),
        count: count + 1,
        seen?: MapSet.member?(cycles, banks)}
    end
  end

  def cycle_count(banks) when is_list(banks) do
    banks
    |> iterate
    |> Enum.find(&Map.fetch!(&1, :seen?))
    |> Map.fetch!(:count)
  end
  def cycle_count(_), do: {:error, "invalid input"}

  def loop_size(banks) when is_list(banks) do
    banks
    |> iterate
    |> Stream.scan(:not_repeated, &process_loop/2)
    |> Enum.find(&is_integer/1)
  end
  def loop_size(_), do: {:error, "invalid input"}

  defp iterate(banks) do
    banks
    |> Stream.with_index
    |> Enum.into(%{}, fn({v, i}) -> {i, v} end)
    |> State.new
    |> Stream.iterate(&process_cycle/1)
  end

  defp process_loop(%{banks: banks, seen?: seen?}, :not_repeated),
    do: if seen?, do: {banks, 1}, else: :not_repeated
  defp process_loop(%{banks: banks}, {repeated, count}),
    do: if banks == repeated, do: count, else: {repeated, count + 1}

  defp process_cycle(%{banks: banks, cycles: cycles, length: l} = state) do
    {position, max} = Enum.max_by(banks, fn({_, v}) -> v end)

    {_, new_banks} = Enum.reduce(
      1..max,
      {position + 1, Map.put(banks, position, 0)},
      &process_banks(&1, &2, l))

    State.update(state, new_banks, cycles)
  end

  defp process_banks(_i, {position, banks}, length)
  when position < length,
    do: {position + 1, Map.update!(banks, position, &(&1 + 1))}
  defp process_banks(_i, {_, banks}, _),
    do: {1, Map.update!(banks, 0, &(&1 + 1))}
end
