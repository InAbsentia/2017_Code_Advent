defmodule Advent.PassphraseTest do
  use ExUnit.Case, async: true

  alias Advent.Passphrase

  describe "duplicates" do
    test "with no repeated words" do
      assert Passphrase.valid?("aa bb cc dd ee")
    end

    test "with a repeated word" do
      refute Passphrase.valid?("aa bb cc dd aa")
    end

    test "with a partially repeated word" do
      assert Passphrase.valid?("aa bb cc dd aaa")
    end

    test "password list" do
      counts =
        "test/support/passphrases.txt"
        |> File.read!
        |> String.trim
        |> String.split("\n")
        |> Passphrase.validate_all
        |> Enum.map(fn({k, v}) -> {k, length(v)} end)

      assert counts[:valid] == 451
      assert counts[:invalid] == 61
    end
  end

  describe "anagrams" do
    test "valid" do
      assert Passphrase.valid?("abcde fghij", [:no_anagrams])
      assert Passphrase.valid?("a ab abc abd abf abj", [:no_anagrams])
      assert Passphrase.valid?("iiii oiii ooii oooi oooo", [:no_anagrams])
    end

    test "invalid" do
      refute Passphrase.valid?("abcde xyz ecdab", [:no_anagrams])
      refute Passphrase.valid?("oiii ioii iioi iiio", [:no_anagrams])
    end

    test "password list" do
      counts =
        "test/support/passphrases.txt"
        |> File.read!
        |> String.trim
        |> String.split("\n")
        |> Passphrase.validate_all([:no_anagrams])
        |> Enum.map(fn({k, v}) -> {k, length(v)} end)

      assert counts[:valid] == 223
      assert counts[:invalid] == 289
    end
  end
end
