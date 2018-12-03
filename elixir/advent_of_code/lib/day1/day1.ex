defmodule AdventOfCode.Day1 do
  @moduledoc """
    Day 1.

    Calculate frequency starting from 0 and adding/subtracting depending on
    the input given.
    i.e. +1 will increase 1, -1 will decrease 1.
  """

  @data Path.join(["day1.sample_input.txt"])

  def read do
    File.stream!(@data, [], :line)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> frequency(0)
  end

  def read_until_first_repeat do
    changes =
      File.stream!(@data, [], :line)
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()
    frequency(changes, 0, MapSet.new(), changes)
  end

  @doc """
  Frequency is calculated by parsing input and adding or subtracting from the current
  value.

  i.e. n = "+3", current = 0 so we'll return 3
  i.e. n = "-2", current = 3 so we'll return 1
  """
  def frequency(["+" <> n | tail], current) do
    value =
      n
      |> String.to_integer()
      |> Kernel.+(current)
    frequency(tail, value)
  end

  def frequency(["-" <> n | tail], current) do
    value =
      current
      |> Kernel.-(String.to_integer(n))
    frequency(tail, value)
  end

  def frequency([], current), do: current

  # We will define frequency/4 to track repeated frequencies
  def frequency(["+" <> n | tail], current, seen, changes) do
    value =
      n
      |> String.to_integer()
      |> Kernel.+(current)

    if already_seen?(seen, value) do
      value
    else
      seen = MapSet.put(seen, value)
      frequency(tail, value, seen, changes)
    end
  end

  def frequency(["-" <> n | tail], current, seen, changes) do
    value =
      current
      |> Kernel.-(String.to_integer(n))

    if already_seen?(seen, value) do
      value
    else
      seen = MapSet.put(seen, value)
      frequency(tail, value, seen, changes)
    end
  end

  def frequency([], current, seen, changes) do
    frequency(changes, current, seen, changes)
  end

  defp already_seen?(seen, value) do
    MapSet.member?(seen, value)
  end
end
