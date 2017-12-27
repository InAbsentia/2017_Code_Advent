defmodule Advent.Registers do
  @conditions %{
    ">" => &Kernel.>/2,
    "<" => &Kernel.</2,
    ">=" => &Kernel.>=/2,
    "<=" => &Kernel.<=/2,
    "==" => &Kernel.==/2,
    "!=" => &Kernel.!=/2}

  @operations %{"inc" => &Kernel.+/2, "dec" => &Kernel.-/2}

  def largest(instructions) do
    instructions
    |> run
    |> Enum.max_by(fn {_, v} -> v end)
    |> elem(1)
  end

  def highest_value(instructions) do
    {:ok, agent} = Agent.start(fn -> 0 end)
    run(instructions, fn value ->
      Agent.update(agent, &Enum.max([&1, value]))
    end)

    Agent.get(agent, fn val -> val end)
  end

  defp run(instructions, callback \\ fn x -> x end),
    do: Enum.reduce(instructions, %{}, &apply_instruction(&1, &2, callback))

  defp apply_instruction(instruction, registers, callback) do
    if condition_matches?(registers, instruction.condition) do
      operation = @operations[instruction.operation]
      new_value =
        registers
        |> get_register(instruction.register)
        |> operation.(instruction.amount)

      callback.(new_value)
      Map.put(registers, instruction.register, new_value)
    else
      registers
    end
  end

  defp get_register(registers, name),
    do: Map.get(registers, name, 0)

  defp condition_matches?(registers, condition) do
    {register, op, value} = parse_condition(condition)
    registers |> get_register(register) |> op.(value)
  end

  defp parse_condition(condition) do
    [register, op, value] = String.split(condition, " ")
    {register, @conditions[op], String.to_integer(value)}
  end
end
