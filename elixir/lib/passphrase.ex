defmodule Advent.Passphrase do

  def valid?(phrase, opts \\ [])
  def valid?(phrase, opts) when is_binary(phrase) do
    words = phrase |> String.downcase |> String.split(" ")

    if Enum.member?(opts, :no_anagrams),
      do: anagrams?(words),
      else: dupes?(words)
  end
  def valid?(_, _), do: {:error, "invalid input"}

  def validate_all(phrases, opts \\ []) when is_list(phrases) do
    Enum.reduce(phrases, %{valid: [], invalid: []}, fn(phrase, acc) ->
      if valid?(phrase, opts) do
        Map.update!(acc, :valid, &[phrase | &1])
      else
        Map.update!(acc, :invalid, &[phrase | &1])
      end
    end)
  end

  defp dupes?(words) do
    words == Enum.uniq(words)
  end

  defp anagrams?(words) do
    words == Enum.uniq_by(words, fn(word) ->
      word |> String.split("", trim: true) |> Enum.sort
    end)
  end
end
